#define ROUNDS 50		// For averaging the timings
#define PAGE_COUNT 1024*8//1024*64
#define PAGE_SIZE 4096

#define WASMPTR uint32_t

uint32_t measure_read(void *memory);
void storefor_write_SAB();

int probemap_storeforwardleakage(l3pp_t l3);
void storefor_write(void *app_state_ptr, int benchmarkruns);
int try_to_create_es(uint32_t *address_arr, uint32_t number_of_storefor_add, uint32_t startTime, uint32_t endTime, void* ptr_l3);

extern uint32_t read_mem_ptr(uint32_t);
extern uint32_t SAB_lib_get_counter_value_storefor(void);
extern uint32_t store_for_js(WASMPTR, uint32_t, WASMPTR, uint32_t, WASMPTR, uint32_t, uint32_t, uint32_t, WASMPTR);
extern uint32_t store_for_js_SAB(uint32_t);