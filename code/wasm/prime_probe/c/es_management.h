#define SAMPLES 50
#define MIN_ES 120

struct app_state
{
  l3pp_t l3;
  RES_TYPE *res;
  int l3_threshold;
  int number_of_samples_old;
  int monitored_es_changed;
  RES_TYPE *monitored_es_index_vec; // index vector for currently monitored es
                                    // (range [0,nmonitored-1])
  int last_min_index;
  int last_max_index;
  int type;

  int *idle_mean_values;
  int idle_times_min_index;
  int idle_times_max_index;
  int *current_mean_values;
  int *interesting_cache_sets; // index vector for cache sets
};

// tell javascript main thread ptr add from res array in wasm memory region
extern void set_ptr_to_data(uint32_t, int, int, int);
extern void set_current_times_ptr(uint32_t);
extern void set_idle_times_ptr(uint32_t, uint32_t);
extern void set_number_of_observed_cache_sets(int);
extern void set_monitored_es_index_vec_ptr(uint32_t, uint32_t);
extern void
js_repeatedprobe(uint32_t, uint32_t, int,
                 uint32_t); // uint8ptrMonitorhead, uint8ptrBmonitorhead,
                            // records, uint8ptrResults

extern void print_plot_data(void);

uint64_t get_time_in_ms();
int mem_access_testing(int rounds, int print);

double measure_mean_access_time(struct app_state *this_app_state, int samples);
void change_type(void *app_state_ptr, int type);
void set_monitored_es_arr(void *app_state_ptr, int *indices_arr,
                          int indices_arr_size);
void set_monitored_es(void *app_state_ptr, int min_index, int max_index);

void build_es(void *app_state_ptr, int max_es, enum search_methods search_method);
int build_es_ex(void *app_state_ptr, int max_es, int benchmarkmode,
                int benchmarkruns, enum search_methods search_method);
uint32_t set_l3pp_t(void *app_state_ptr, int max_es, enum search_methods search_method);
void storefor_build_es(void *app_state_ptr, int max_es, int benchmarkruns);

void prime_spam_es(void *app_state_ptr, int duration_sec, int option);
void sample_es(void *app_state_ptr, int number_of_samples, int slot_time
#ifdef WASM
               ,
               int plot, int primeprobe_js
#endif
);

// implement in c instead of javascript to get a more generic approach (useable
// without wasm)
void get_mean_evictions_sets(void *app_state_ptr, int *idle_mean_values,
                             int number_of_samples);
void get_idle_times(void *app_state_ptr, int min_index, int max_index,
                    int number_of_samples);
// called after get_idle_times, test eviction sets used in get_idle_times
void find_interesting_eviction_sets(void *app_state_ptr, float threshold_factor,
                                    int number_of_samples);