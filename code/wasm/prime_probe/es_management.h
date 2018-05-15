#define SAMPLES 50

struct app_state {
  l3pp_t l3;
  RES_TYPE *res;
  int l3_threshold;
  int number_of_samples_old;
  int monitored_es_changed;
};

//tell javascript main thread ptr add from res array in wasm memory region
extern void set_ptr_to_data(uint32_t, int, int, int);

extern void print_plot_data(void);

uint32_t get_time_in_ms();
void set_monitored_es(void* app_state_ptr, int min_index, int max_index);
void build_es(void* app_state_ptr, int max_es);
void sample_es(void* app_state_ptr, int number_of_samples, int slot_time);