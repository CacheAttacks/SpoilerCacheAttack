#include <emscripten.h>

//javascript function stubs
extern int SAB_lib_get_counter_value(); //uses lib call to get counter value
extern void SAB_terminate_counter_sub_worker(); //call at end of c code, otherwise sub worker do not terminate
extern float SAB_get_resolution_ns(int samples); //determine possible resolution of SAB counter 
extern int SAB_func_ptr_get_counter_value(); //func ptr for direct function call from c
extern void SAB_wasmMemory_write_counter_value(); //write counter value in Module['wasmMemory']

//input measurement function, printf resolution 
void test_resolution_SAB(int (*measure_func)(), float resolution_ns);

//wrapper for SAB_counter_lib_get_value
int wrapper_SAB_lib_get_counter_value();

//wrapper for EM_ASM code
int wrapper_SAB_EM_ASM_get_counter_value();

//test if direct call improves performance compared to wrapper call
//void SAB_test_resolution_direct(float resolution_ns);

//compare different call methods for SAB counter:
//lib call 
//direct function ptr
//EM ASM
//write to Module['wasmMemory']
void SAB_bench_call_methods();

//test results:
//lib call is faster than EM_ASM and direct function pointers
//direct funcion pointers and EM_ASM are nearly the same speed wise
//direct call of measure_func do not improve performance