// javascript function stubs
extern uint32_t
SAB_lib_get_counter_value(void); // uses lib call to get counter value
extern void SAB_terminate_counter_sub_worker(
    void); // call at end of c code, otherwise sub worker do not terminate
extern float SAB_get_resolution_ns(
    int samples); // determine possible resolution of SAB counter
extern uint32_t SAB_func_ptr_get_counter_value(
    void); // func ptr for direct function call from c

extern void SAB_lib_wasmMemory_init_buffer(void);
extern void SAB_lib_wasmMemory_write_counter_value(
    void); // write counter value in Module['wasmMemory']
extern uint32_t SAB_func_ptr_write_counter_value(
    void); // func ptr for direct function call from c

extern uint32_t Performance_now(void);
extern void test_find();



void counter_consistency_test(int mean, uint32_t counts, uint32_t range);
float get_timer_resolution();
//void print_res(l3pp_t l3, RES_TYPE *res, int nmonitored);

// input measurement function, printf resolution
void test_resolution_SAB(uint32_t (*measure_func)(), float resolution_ns);

// wrapper for SAB_counter_lib_get_value
uint32_t wrapper_SAB_lib_get_counter_value();

// wrapper for EM_ASM code
uint32_t wrapper_SAB_EM_ASM_get_counter_value();

// wrapper for SAB_wasmMemory_write_counter_value
uint32_t wrapper_SAB_lib_wasmMemory_get_counter_value();

// wrapper for EM_ASM code
uint32_t wrapper_SAB_EM_ASM_wasmMemory_get_counter_value();

// called by javascript
uint32_t *wasmMemory_get_buffer(int size);
uint32_t read_mem(uint32_t *buf);
void bla(int *buf);
int doSomething();

// test if direct call improves performance compared to wrapper call
// void SAB_test_resolution_direct(float resolution_ns);

// compare different call methods for SAB counter:
// lib call
// direct function ptr
// EM ASM
// write to Module['wasmMemory']
void SAB_bench_call_methods();

// test results:
// lib call is faster than EM_ASM and direct function pointers
// direct funcion pointers and EM_ASM have nearly the same performance
// direct call of measure_func do not improve performance