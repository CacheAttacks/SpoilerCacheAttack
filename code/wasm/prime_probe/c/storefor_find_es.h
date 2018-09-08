#define ROUNDS 100		// For averaging the timings
#define PAGE_COUNT 1024*100
#define PAGE_SIZE 4096

#define WASMPTR uint32_t

uint32_t measure_read(void *memory);
void storefor_write_SAB();
void storefor_write();
int try_to_create_es(uint32_t *address_arr, uint32_t number_of_storefor_add);

extern uint32_t read_mem_ptr(uint32_t);
extern uint32_t SAB_lib_get_counter_value_storefor(void);
extern uint32_t store_for_js(WASMPTR, uint32_t, WASMPTR, uint32_t, WASMPTR);
extern uint32_t store_for_js_SAB(uint32_t);