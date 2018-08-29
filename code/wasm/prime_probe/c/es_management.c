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

// use set_monitored_es beforehand to set the observed es
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

// set non-cohesive es
// could replace set_monitored_es (refactoring effort does not worth it now)
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

void build_es(void *app_state_ptr, int max_es)
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
    );
  } while (ngroups < MIN_ES && (ngroups < max_es || max_es == 0));
}

int build_es_ex(void *app_state_ptr, int max_es, int benchmarkmode,
                int benchmarkruns)
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
    uint32_t *timer_array = calloc(BENCHMARKRUNS, sizeof(uint32_t));
    for (int i = 0; i < BENCHMARKRUNS; i++)
    {
      uint32_t timer_before = get_time_in_ms();
      this_app_state->l3 =
          l3_prepare(NULL, this_app_state->l3_threshold, max_es);
      uint32_t timer_after = get_time_in_ms();

      printf_ex("Eviction set total time: %u sec\n",
             (timer_after - timer_before) / 1000);
      l3_release(this_app_state->l3);
      timer_array[i] = timer_after - timer_before;
    }
    for (int i = 0; i < BENCHMARKRUNS; i++)
    {
      printf_ex("%u ", timer_array[i]);
    }
    printf_ex("\n");
  }
  else
  {
    uint32_t timer_before = get_time_in_ms();
    this_app_state->l3 = l3_prepare(NULL, this_app_state->l3_threshold, max_es);
    uint32_t timer_after = get_time_in_ms();

    printf_ex("Eviction set total time: %u sec\n",
           (timer_after - timer_before) / 1000);
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

void prime_spam_es(void *app_state_ptr, int duration_sec)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  // 2500 counter iterations ~ 10us

  if (!this_app_state->l3)
  {
    printf_ex("app_state_ptr->l3 is null! Already called build_es?\n");
    return;
  }
  int number_of_samples = 1000000;
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
      l3_repeatedprobe_spam_fast(this_app_state->l3, number_of_samples);
    } 
    else 
    {
      // l3_repeatedprobe(this_app_state->l3, number_of_samples, this_app_state->res,
      //                 0, this_app_state->type);
      l3_repeatedprobe_spam(this_app_state->l3, number_of_samples);
    }
  }
}

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

// threshold_factor: compare idle values with current values to get interesting
// cache sets
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

void storefor_build_es(void *app_state_ptr, int max_es){
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  storefor_write();
}