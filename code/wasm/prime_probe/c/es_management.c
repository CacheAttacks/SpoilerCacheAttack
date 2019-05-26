#include <assert.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "printf_wrapper.h"
#include "es_management.h"
#include "storefor_find_es.h"


#define CHECK_BIT(var, pos) ((var) & (1 << (pos)))

/**
 * @brief Get the current time in ms. Use Performance.now() or clock_gettime.
 * 
 * @return uint64_t current timestamp in ms
 */
uint64_t get_time_in_ms()
{
#ifdef WASM
  return Performance_now();
#else
  struct timespec spec;
  clock_gettime(CLOCK_REALTIME, &spec);
  return spec.tv_sec * 1000 + spec.tv_nsec / 1000000;
#endif
}


#define BLOCK_SIZE 8
/**
 * @brief Get mem access time for data access.
 * 
 * @param random random=1 => randomize access
 * @param rounds Increase to reduce the impact of outliers
 * @param print print=1 => print results
 * @return int 
 */
int test_mem_access(int random, int rounds, int print)
{
  int pages = 1024 * 1024 * 20;
  int bufsize = BLOCK_SIZE * pages;
  if (bufsize > 1024 * 1024 * 200)
  {
    printf_ex("bufsize to big!");
    exit(1);
  }
  char *buffer = mmap(NULL, bufsize, PROT_READ | PROT_WRITE,
                      MAP_ANON | MAP_PRIVATE, -1, 0);
  // char *buffer = (char*)calloc(bufsize,1);
  flush_l3(buffer, pages, BLOCK_SIZE);
  srand(32); // should only be called once
  void *randomPtr;
  int randomIndex;
  int sum = 0;
  int flush = 0;
  uint32_t *counter = malloc(sizeof(uint32_t) * rounds * 4);
  for (int i = 0; i < rounds; i++)
  {
    randomIndex = i;
    if (random)
    {
      randomIndex = rand() % pages * BLOCK_SIZE;
    }
    randomPtr = (void *)(&buffer[randomIndex]);

    void *randomPtr_page = (void *)(((int)randomPtr >> 12) << 12);
    memaccess(randomPtr_page);

    counter[i * 4] = memaccesstime(randomPtr, info);
    memaccesstime((void *)((int)randomPtr + 1), info);
    counter[i * 4 + 1] = memaccesstime(randomPtr, info);

    if (flush)
      flush_l3(buffer, pages, BLOCK_SIZE);

    memaccess(randomPtr_page);

    counter[i * 4 + 2] = memaccesstime(randomPtr, info);
    counter[i * 4 + 3] = memaccesstime(randomPtr, info);

    // memaccesstime_test(randomPtr);
    // memaccesstime_test(randomPtr);
    // memaccesstime_test(randomPtr);
    sum += counter[i * 4];
  }

  if (print)
  {
    for (int i = 0; i < rounds; i++)
    {
      printf_ex("index: %p ,", randomPtr);
      printf_ex("%" PRIu32 ", %" PRIu32 ", ", counter[i * 4], counter[i * 4 + 1]);

      if (flush)
        printf_ex("flush L3, ");

      printf_ex("%" PRIu32 ", %" PRIu32 "\n", counter[i * 4 + 2],
             counter[i * 4 + 3]);
    }
  }

  free(buffer);
  return sum / rounds;
}

/**
 * @brief Get mem access time comparison for cache and uncached data.
 * 
 * @param rounds Increase to reduce the impact of outliers
 * @param print print=1 => print results
 * @return int 
 */
int mem_access_testing(int rounds, int print)
{
  printf_ex("random access %i rounds\n", rounds);
  int mean_random = test_mem_access(1, rounds, print);
  printf_ex("mean:%i\n", mean_random);
  printf_ex("linear access\n");
  int mean_linear = test_mem_access(0, rounds, print);
  printf_ex("mean:%i\n", mean_linear);
  // SAB_terminate_counter_sub_worker();
  // exit(1);
  if (mean_random < mean_linear - 10)
  {
    printf_ex("cannot differ random/linear accesses!\n");
  }
  if (mean_random - mean_linear <= 10)
  {
    printf_ex("mean_random - mean_linear < 10\n");
    // exit(1);
  }

  int threshold = mean_linear + (((mean_random - mean_linear) / 2));
  printf_ex("auto-detected random/linear threshold: %i\n", threshold);
  return threshold;
}


/**
 * @brief Measures mean access time. Use set_monitored_es beforehand to set the observed es.
 * 
 * @param this_app_state Ptr to global data struct
 * @param samples Increase to reduce the impact of outliers
 * @return double Return the mean access value
 */
double measure_mean_access_time(struct app_state *this_app_state, int samples)
{
  sample_es((void *)this_app_state, samples, 0
#ifdef WASM
            ,
            0, 0
#endif
  );
  double access_time_mean = 0;
  int res_size =
      this_app_state->l3->nmonitored * this_app_state->number_of_samples_old;
  for (int i = 0; i < res_size; i++)
  {
    access_time_mean += this_app_state->res[i];
  }
  access_time_mean /= res_size;
  return access_time_mean;
}

/**
 * @brief Monitor the lower half of all "super"-es. Each "super"-es can be expanded to 64 es. 
 * 
 * @param app_state_ptr Ptr to global data struct
 */
void set_monitored_es_lower_half(void *app_state_ptr)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets / 64;
  int max_index = nmonitored - 1;
  int min_index = 0;

  l3_unmonitorall(this_app_state->l3);

  // printf_ex("monitor from %i to %i\n", min_index, max_index);

  for (int i = min_index * 64; i < (max_index + 1) * 64; i += 64)
    if (!CHECK_BIT(i / 64, 5))
      l3_monitor(this_app_state->l3, i);

  this_app_state->monitored_es_changed = 1;
}

/**
 * @brief Change the prime and probe type. See probe.c for the different types
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param type See probe.c for more details
 */
void change_type(void *app_state_ptr, int type)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  if (type == 0 || ((type - 10) >= 1 && (type - 10) <= 9) ||
      ((type - 100) >= 10 && (type - 100) <= 16) || type == 22 || type == 24 ||
      type == 28)
  {
    this_app_state->type = type;
    printf_ex("type changed to %i\n", type);
  }
  else
  {
    printf_ex("type not found! type still %i\n", this_app_state->type);
  }
}

/**
 * @brief Set non-cohesive es as monitored. Could be merged with set_monitored_es.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param indices_arr Array with es indices
 * @param indices_arr_size Size of indices_arr (welcome to c)
 */
void set_monitored_es_arr(void *app_state_ptr, int *indices_arr,
                          int indices_arr_size)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets / 64;
  int max_index = nmonitored - 1;
  printf_ex("add: %p\n", indices_arr);

  for (int i = 0; i < indices_arr_size; i++)
  {
    int current_index = indices_arr[i];
    printf_ex("cur: %i\n", current_index);
    if (current_index < 0)
    {
      printf_ex("%i < 0\n", current_index);
      return;
    }
    if (current_index >= max_index)
    {
      printf_ex("%i >= number_of_es\n", current_index);
      return;
    }
  }

  l3_unmonitorall(this_app_state->l3);

  memset(this_app_state->monitored_es_index_vec, 0,
         nmonitored * sizeof(RES_TYPE));

  for (int i = 0; i < indices_arr_size; i++)
  {
    l3_monitor(this_app_state->l3, indices_arr[i] * 64);
    this_app_state->monitored_es_index_vec[indices_arr[i]] = RES_TYPE_MAX;
  }

  // sets these values, to preserve compatibility with set_monitored_es
  this_app_state->monitored_es_changed = 1;
  this_app_state->last_min_index = -2;
  this_app_state->last_max_index = -2;
}

/**
 * @brief Set es range as monitored. Could be merged with set_monitored_es_arr
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param min_index have to >= 0, defines lower limit of the es range
 * @param max_index have to < numberOfEs, defines upper limit of the es range
 */
void set_monitored_es(void *app_state_ptr, int min_index, int max_index)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  if (this_app_state->last_min_index == min_index &&
      this_app_state->last_max_index == max_index)
  {
    return;
  }
  // printf_ex("min_index:%i ,max_index:%i\n", min_index, max_index);
  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets / 64;
  // printf_ex("nmonitored: %i\n", nmonitored);
  if (min_index == -1 && max_index == -1)
  {
    max_index = nmonitored - 1;
    min_index = 0;
  }
  if (min_index < 0)
  {
    printf_ex("min_index < 0\n");
    return;
  }
  if (max_index >= nmonitored)
  {
    printf_ex("max_index >= number_of_es\n");
    return;
  }
  if (max_index < min_index)
  {
    printf_ex("max_index < min_index\n");
    return;
  }

  l3_unmonitorall(this_app_state->l3);

  // printf_ex("monitor from %i to %i\n", min_index, max_index);

  for (int i = min_index * 64; i < (max_index + 1) * 64; i += 64)
    l3_monitor(this_app_state->l3, i);
  this_app_state->monitored_es_changed = 1;
  this_app_state->last_min_index = min_index;
  this_app_state->last_max_index = max_index;

  memset(this_app_state->monitored_es_index_vec, 0,
         nmonitored * sizeof(RES_TYPE));
  memset(this_app_state->monitored_es_index_vec + min_index, 1,
         (max_index - min_index + 1) * sizeof(RES_TYPE));
}

/**
 * @brief wrapper for build_es_ex
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param max_es 
 * @param search_methods Select between DEFAULT and STOREFORWARDLEAKAGE
 */
void build_es(void *app_state_ptr, int max_es, enum search_methods search_method)
{
  int ngroups;
  do
  {
    ngroups = build_es_ex(app_state_ptr, max_es,
#ifdef BENCHMARKMODE
                          1, BENCHMARKRUNS
#else
                          0, 0
#endif
, search_method);
  } while (ngroups < MIN_ES && (ngroups < max_es || max_es == 0));
}

/**
 * @brief es search
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param max_es Break search after max_es "super es" were found. Each "super es" is extended to 64 es.
 * @param benchmarkmode benchmarkmode=1 => activates benchmarkmode (parameter could be merged with benchmarkruns)
 * @param benchmarkruns Define number of runs (set benchmarkmode=1)
 * @param search_methods Select between DEFAULT and STOREFORWARDLEAKAGE
 * @return int Return number of es found
 */
int build_es_ex(void *app_state_ptr, int max_es, int benchmarkmode,
                int benchmarkruns, enum search_methods search_method)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  if (!this_app_state->l3_threshold)
  {
    printf_ex("l3_threshold not set!\n");
    exit(1);
  }

  // if es is already present, clear allocated mem
  if (this_app_state->l3)
  {
    l3_release(this_app_state->l3);
    this_app_state->l3 = 0;
  }
  if (this_app_state->res)
  {
    free(this_app_state->res);
    this_app_state->res = 0;
  }

  if (!max_es)
  {
    max_es = INT_MAX;
  }

  // reset value to trigger reallocation of res array
  this_app_state->number_of_samples_old = 0;

#ifdef WASM
  warmup(1024 * 1024 * 128); // warm up 2^27 counts operations ~ 2^30
                             // cyclesthis_app_state->last_min_index
  printf_ex("warm-up finished\n");
#endif

  if (benchmarkmode)
  {
    uint32_t *timer_array = calloc(benchmarkruns, sizeof(uint32_t));
    for (int i = 0; i < benchmarkruns; i++)
    {      
      timer_array[i] = set_l3pp_t(app_state_ptr, max_es, search_method);
      l3_release(this_app_state->l3);
    }
    for (int i = 0; i < benchmarkruns; i++)
    {
      printf_ex("%u ", timer_array[i]);
    }
    printf_ex("\n");
  }
  else
  {
    set_l3pp_t(app_state_ptr, max_es, search_method);
  }
  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets / 64;
  printf_ex("nmonitored: %i\n", nmonitored);

  // create and set monitored es index vec
  // size of this vector is not known in advance
  if (this_app_state->monitored_es_index_vec)
    free(this_app_state->monitored_es_index_vec);
  this_app_state->monitored_es_index_vec = calloc(sizeof(RES_TYPE), nmonitored);

  set_monitored_es(app_state_ptr, -1, -1);

  set_monitored_es_index_vec_ptr(
      (uint32_t)this_app_state->monitored_es_index_vec, (uint32_t)nmonitored);

  printf_ex("ncol: %i\n", this_app_state->l3->nmonitored);

  return this_app_state->l3->ngroups;
}

/**
 * @brief Sub function of build_es_ex. Calls l3_prepare for es search.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param max_es Break search after max_es es were found
 * @param search_methods Select between DEFAULT and STOREFORWARDLEAKAGE
 * @return uint32_t Return time in ms required for es search
 */
uint32_t set_l3pp_t(void *app_state_ptr, int max_es, enum search_methods search_method){
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  uint32_t timer_before = get_time_in_ms();
  this_app_state->l3 = l3_prepare(app_state_ptr, NULL, this_app_state->l3_threshold, max_es, search_method);
  uint32_t timer_after = get_time_in_ms();

  printf_ex("Eviction set total time: %u sec\n",
          (timer_after - timer_before) / 1000);
  return timer_after - timer_before;
}

/**
 * @brief Used for storeforwad benchmarks.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param max_es Break search after max_es es were found
 * @param benchmarkruns Define number of benchmarkruns 
 */
void storefor_build_es(void *app_state_ptr, int max_es, int benchmarkruns){
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  storefor_write(app_state_ptr, benchmarkruns);
}

/**
 * @brief Do a prime-spam. Use set_monitored_es_arr or set_monitored_es to set the es-indices.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param duration_sec Duration of prime-spam in secondes
 * @option option=0 => probe_only_split_2 with bprobe, option=1 => probe_only_split_2 without bprobe, option=2 => ptr_arr with bprobe, option=3 => ptr_arr with bprobe
 */
void prime_spam_es(void *app_state_ptr, int duration_sec, int option)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  // 2500 counter iterations ~ 10us

  if (!this_app_state->l3)
  {
    printf_ex("app_state_ptr->l3 is null! Already called build_es?\n");
    return;
  }
  int number_of_samples = 1000000;
  if(option == 1 || option == 3 || option == 5){
    number_of_samples *= 2;
  }
  int nmonitored = this_app_state->l3->nmonitored;

  // if (this_app_state->res)
  // {
  //   free(this_app_state->res);
  // }
  // this_app_state->res = calloc(
  //     number_of_samples * this_app_state->l3->nmonitored, sizeof(RES_TYPE));

  uint64_t before = get_time_in_ms();
  while (get_time_in_ms() - before < duration_sec * 1000)
  {
    if(nmonitored == 1)
    {
      //uint64_t before_2 = get_time_in_ms();
      //l3_repeatedprobe_spam_option(this_app_state->l3, number_of_samples, option);
      if(option == 0){
        l3_repeatedprobe_spam_fast(this_app_state->l3, number_of_samples);
      }
      else {
        l3_repeatedprobe_spam_option(this_app_state->l3, number_of_samples, option);
      }
      //uint64_t after_2 = get_time_in_ms();
      //printf_ex("time:%" PRIu64 "\n", after_2-before_2);
      //l3_repeatedprobe_spam_fast_experimental(this_app_state->l3, number_of_samples);
    } 
    else 
    {
       //l3_repeatedprobe(this_app_state->l3, number_of_samples, this_app_state->res,
                       //0, this_app_state->type);
      //uint64_t before_2 = get_time_in_ms();
      l3_repeatedprobe_spam_option(this_app_state->l3, number_of_samples, option);
      //uint64_t after_2 = get_time_in_ms();
      //printf_ex("time:%" PRIu64 "\n", after_2-before_2);
      //l3_repeatedprobe_spam(this_app_state->l3, number_of_samples);
    }
  }
}

/**
 * @brief Do some Prime-and-Probe measurements.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param number_of_samples How many Prime-and-Probe cycles?
 * @param slot_time Pause between different samples
 * @param plot plot=1 => plot results via R
 * @param primeprobe_js primeprobe_js=1 => Use promeprobe_js instead of wasm. 
 */
void sample_es(void *app_state_ptr, int number_of_samples, int slot_time
#ifdef WASM
               ,
               int plot, int primeprobe_js
#endif
)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  // 2500 counter iterations ~ 10us

  if (!this_app_state->l3)
  {
    printf_ex("app_state_ptr->l3 is null! Already called build_es?\n");
    return;
  }

  if (number_of_samples <= 0)
  {
    number_of_samples = SAMPLES;
  }

  // avoid reallocation of res array if called with same parameter
  if (this_app_state->monitored_es_changed ||
      !this_app_state->number_of_samples_old ||
      this_app_state->number_of_samples_old != number_of_samples)
  {
    if (this_app_state->res)
    {
      free(this_app_state->res);
    }
    this_app_state->monitored_es_changed = 0;
    this_app_state->res = calloc(
        number_of_samples * this_app_state->l3->nmonitored, sizeof(RES_TYPE));
    // for (int i = 0; i < number_of_samples * this_app_state->l3->nmonitored;
    // i+= 4096/sizeof(RES_TYPE))
    //  this_app_state->res[i] = 1;
  }

  uint64_t before = get_time_in_ms();

  if (this_app_state->l3->nmonitored == 1)
  {
    if (primeprobe_js)
    {
      void *monitorhead = this_app_state->l3->monitoredhead[0];
      js_repeatedprobe((uint32_t)monitorhead, (uint32_t)NEXTPTR(monitorhead),
                       number_of_samples, (uint32_t)this_app_state->res);
    }
    else
    {
      l3_repeatedprobe_fast(this_app_state->l3, number_of_samples,
                            this_app_state->res, this_app_state->type);
    }
  }

  else
  {
    l3_repeatedprobe(this_app_state->l3, number_of_samples, this_app_state->res,
                     slot_time, this_app_state->type);
  }

  uint64_t time_dur = get_time_in_ms() - before;
  int opt_primeprobe = (this_app_state->l3->nmonitored == 1) ? 1 : 0;
  uint64_t primeprobe_ops = this_app_state->l3->nmonitored * number_of_samples;
  printf_ex("l3_repeatedprobe %" PRIu64
         "ms (primeprobe_js:%i, opt:%i) per primeprobe op: %f ns\n",
         time_dur, primeprobe_js, opt_primeprobe,
         (double)time_dur / primeprobe_ops * 1000 * 1000);

#ifdef WASM
  // update ptr, type = 0 => Uint16
  set_ptr_to_data((uint32_t)this_app_state->res, number_of_samples,
                  this_app_state->l3->nmonitored, RES_TYPE_JS);

  // printf_ex("set_ptr_to_data: %p\n", this_app_state->res);

  if (plot)
    print_plot_data();
#endif

  this_app_state->number_of_samples_old = number_of_samples;
}

/**
 * @brief Get the mean access times for es'. Use set_monitored_es_arr or set_monitored_es to set the es-indices.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param idle_mean_values Ptr to int array. Save the results here.
 * @param number_of_samples Increase to reduce the impact of outliers
 */
void get_mean_evictions_sets(void *app_state_ptr, int *idle_mean_values,
                             int number_of_samples)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  if (!this_app_state->l3)
  {
    printf_ex("app_state_ptr->l3 is null! Already called build_es?\n");
    return;
  }

  int min_index = this_app_state->idle_times_min_index;
  int max_index = this_app_state->idle_times_max_index;

  // int sample_together = 10;

  // if(this_app_state->res){
  //     free(this_app_state->res);
  // }
  // this_app_state->res = calloc(number_of_samples * 1, sizeof(RES_TYPE));
  RES_TYPE *res = calloc(number_of_samples * 1, sizeof(RES_TYPE));

  for (int i = min_index; i < max_index; i++)
  {
    // int sampled_cur = sample_together;
    // if()
    set_monitored_es(app_state_ptr, i, i);

    l3_repeatedprobe(this_app_state->l3, number_of_samples, res, 0,
                     this_app_state->type);
    uint32_t mean = 0;
    for (int a = 0; a < number_of_samples; a++)
    {
      mean += res[a];
    }
    mean /= number_of_samples;
    // printf_ex("%li ", mean);

    idle_mean_values[i - min_index] = mean;
  }

  // get idle mean
}

/**
 * @brief Get the mean access times for es'. Use an own es range. Saves the results in the global app_state_ptr struct.
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param min_index >= 0, defines lower limit of the es range
 * @param max_index have to < numberOfEs, defines upper limit of the es range
 * @param number_of_samples Increase to reduce the impact of outliers
 */
void get_idle_times(void *app_state_ptr, int min_index, int max_index,
                    int number_of_samples)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  int nmonitored = l3_getSets(this_app_state->l3) / 64;
  if (min_index == -1 && max_index == -1)
  {
    max_index = nmonitored - 1;
    min_index = 0;
  }
  if (min_index < 0)
  {
    printf_ex("min_index < 0\n");
    return;
  }
  if (max_index >= nmonitored)
  {
    printf_ex("max_index >= number_of_es\n");
    return;
  }
  if (max_index < min_index)
  {
    printf_ex("max_index < min_index\n");
    return;
  }

  this_app_state->idle_times_min_index = min_index;
  this_app_state->idle_times_max_index = max_index;
  if (this_app_state->idle_mean_values)
  {
    free(this_app_state->idle_mean_values);
  }
  this_app_state->idle_mean_values =
      calloc(max_index - min_index + 1, sizeof(RES_TYPE));
  get_mean_evictions_sets(app_state_ptr, this_app_state->idle_mean_values,
                          number_of_samples);

  // set ptr for javascript env
  set_idle_times_ptr((uint32_t)this_app_state->idle_mean_values,
                     sizeof(RES_TYPE));

  int number_of_observed_cache_sets = this_app_state->idle_times_max_index -
                this_app_state->idle_times_min_index + 1;

  set_number_of_observed_cache_sets(number_of_observed_cache_sets);
}

/**
 * @brief Compare idle values with current values to get interesting cache sets
 * 
 * @param app_state_ptr Ptr to global data struct
 * @param threshold_factor mean access time have to greater than threshold_factor * idle mean value
 * @param number_of_samples Increase to reduce the impact of outliers
 */
void find_interesting_eviction_sets(void *app_state_ptr, float threshold_factor,
                                    int number_of_samples)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  int number_of_observed_cache_sets = this_app_state->idle_times_max_index -
                                      this_app_state->idle_times_min_index + 1;

  // get current mean access time values for selected cache sets
  this_app_state->current_mean_values =
      calloc(number_of_observed_cache_sets, sizeof(RES_TYPE));
  get_mean_evictions_sets(app_state_ptr, this_app_state->current_mean_values,
                          number_of_samples);

  // set ptr for javascript env
  set_current_times_ptr((uint32_t)this_app_state->current_mean_values);

  if (this_app_state->interesting_cache_sets)
    free(this_app_state->interesting_cache_sets);
  this_app_state->interesting_cache_sets =
      calloc(number_of_observed_cache_sets, sizeof(RES_TYPE));

  // printf_ex("interesting cache sets: ");
  for (int i = 0; i < number_of_observed_cache_sets; i++)
  {
    // printf_ex("%i(%i) ", this_app_state->current_mean_values[i],
    // this_app_state->idle_mean_values[i]);
    if (this_app_state->current_mean_values[i] >
        threshold_factor * this_app_state->idle_mean_values[i])
    {
      this_app_state->interesting_cache_sets[i] = 1;
      // printf_ex("%i ", i);
    }
  }
  // putchar('\n');
}

void set_storefor_parameters(void *app_state_ptr, int storefor_window_size, int storefor_rounds, int storefor_threshold_search_for_es)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  this_app_state->storefor_window_size = storefor_window_size;
  this_app_state->storefor_rounds = storefor_rounds;
  this_app_state->storefor_threshold_search_for_es = storefor_threshold_search_for_es;
}

void set_l3_cache_parameters(void *app_state_ptr, int l3_cache_associativity, int l3_cache_sets, int l3_cache_slices, int l3_cache_line_size, int l3_cache_size_multi)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  this_app_state->l3_cache_associativity = l3_cache_associativity;
  this_app_state->l3_cache_sets = l3_cache_sets;
  this_app_state->l3_cache_slices = l3_cache_slices;
  this_app_state->l3_cache_line_size = l3_cache_line_size;
  this_app_state->l3_cache_size_multi = l3_cache_size_multi;
}