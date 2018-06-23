#define SAMPLES 50
#define MIN_ES 120

struct app_state {
  l3pp_t l3;
  RES_TYPE *res;
  int l3_threshold;
  int number_of_samples_old;
  int monitored_es_changed;
  int last_min_index;
  int last_max_index;
  int type;

  int *idle_mean_values;
  int idle_times_min_index;
  int idle_times_max_index;
  int *interesting_cache_sets; //index vector for cache sets
};

//tell javascript main thread ptr add from res array in wasm memory region
extern void set_ptr_to_data(uint32_t, int, int, int);

extern void print_plot_data(void);

uint64_t get_time_in_ms();
double measure_mean_access_time(struct app_state* this_app_state, int samples);
void change_type(void* app_state_ptr, int type);
void set_monitored_es(void* app_state_ptr, int min_index, int max_index);
void build_es(void* app_state_ptr, int max_es);
int build_es_ex(void* app_state_ptr, int max_es, int benchmarkmode, int benchmarkruns);
void sample_es(void* app_state_ptr, int number_of_samples, int slot_time
#ifdef WASM
, int plot
#endif
);

//implement in c instead of javascript to get a more generic approach (useable without wasm)
void get_mean_evictions_sets(void* app_state_ptr, int *idle_mean_values);
void get_idle_times(void* app_state_ptr, int min_index, int max_index);
//called after get_idle_times, test eviction sets used in get_idle_times
void find_interesting_eviction_sets(void* app_state_ptr);