#define SAMPLES 50

struct app_state {
  l3pp_t l3;
  RES_TYPE *res;
  int l3_threshold;
  int number_of_samples_old;
  int monitored_es_changed;
  int last_min_index;
  int last_max_index;
  int type;
};

//tell javascript main thread ptr add from res array in wasm memory region
extern void set_ptr_to_data(uint32_t, int, int, int);

extern void print_plot_data(void);

uint64_t get_time_in_ms();
double mesure_mean_access_time(struct app_state* this_app_state, int samples);
void change_type(void* app_state_ptr, int type);
void set_monitored_es(void* app_state_ptr, int min_index, int max_index);
void build_es(void* app_state_ptr, int max_es);
void build_es_ex(void* app_state_ptr, int max_es, int benchmarkmode, int benchmarkruns);
void sample_es(void* app_state_ptr, int number_of_samples, int slot_time
#ifdef WASM
, int plot
#endif
);
