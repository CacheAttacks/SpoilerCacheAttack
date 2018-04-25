#include "SABcounter.h"

//used for SAB_wasmMemory_write_counter_value 
int *SAB_global_counter_buffer = 0;

void SAB_test_resolution(uint64_t (*measure_func)(), float resolution_ns){
  for(int i = 0; i< 20; i++) {
    uint64_t v1 = (*measure_func)();
    uint64_t v2 = (*measure_func)();
    float diff_ns = (v2-v1)*resolution_ns;
    printf("%" PRIu64 "(%0.1fns), ", v2-v1, diff_ns);
  }
  putchar('\n');
}

uint64_t wrapper_SAB_lib_get_counter_value(){
  return SAB_lib_get_counter_value();
}

uint64_t wrapper_SAB_EM_ASM_get_counter_value(){
  return EM_ASM_INT({
    return Module['sharedArrayCounter'][0];
  });
}

uint64_t wrapper_SAB_lib_wasmMemory_get_counter_value(){
    SAB_lib_wasmMemory_write_counter_value();
    return SAB_global_counter_buffer[0];
}

uint64_t wrapper_SAB_EM_ASM_wasmMemory_get_counter_value(){
  EM_ASM({
    Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] = 
        Module['sharedArrayCounter'][0];
  });
  return SAB_global_counter_buffer[0];
}

uint64_t wrapper_SAB_func_ptr_wasmMemory_get_counter_value(){
  (*((int (*)())SAB_func_ptr_write_counter_value()))();
  return SAB_global_counter_buffer[0];
}


int* wasmMemory_get_buffer(int size){
  SAB_global_counter_buffer = (int*)malloc(sizeof(int)*size);
  for(int i=0; i<size;i++)
  {
    SAB_global_counter_buffer[i] = 42;
  }
  //printf("buf add: %#010x\n", (unsigned int)SAB_global_counter_buffer);
  return SAB_global_counter_buffer;
}

int read_mem(int *buf){
  printf("offset %#010x\n", (unsigned int)buf);
  printf("buf[0]: %i\n", *buf);
  printf("buf[1]: %i\n", buf[1]);
  return *buf;
}

void bla(int *buf){
  int before = *SAB_global_counter_buffer;
  doSomething();
  int after = *SAB_global_counter_buffer;
  int diff = after - before;
  printf("diff %i", diff);
}

int doSomething(){
  int a=0;
  for(int i=0; i< 10000; i++){
    a++;
  }
  return a;
}

// void SAB_test_resolution_direct(float resolution_ns){
//   for(int i = 0; i< 20; i++) {
//     int v1 = shared_array_counter_get_value();
//     int v2 = shared_array_counter_get_value();
//     float diff_ns = (v2-v1)*resolution_ns;
//     printf("%i(%0.1fns), ", v2-v1, diff_ns);
//   }
//   putchar('\n');
// }

void SAB_bench_call_methods(){
  float resolution_ns = SAB_get_resolution_ns(100);
  printf("resolution SAB: %f ns\n", resolution_ns);

  printf("call SAB_lib_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_lib_get_counter_value, resolution_ns);

  printf("call SAB_EM_ASM_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_EM_ASM_get_counter_value, resolution_ns);

  printf("call SAB_func_ptr_get_counter_value:\n");
  SAB_test_resolution((uint64_t (*)())SAB_func_ptr_get_counter_value(), resolution_ns);


  SAB_lib_wasmMemory_init_buffer();
  printf("call SAB_lib_wasmMemory_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_lib_wasmMemory_get_counter_value, resolution_ns);

  printf("call SAB_EM_ASM_wasmMemory_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_EM_ASM_wasmMemory_get_counter_value, resolution_ns);

  printf("call SAB_func_ptr_write_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_func_ptr_wasmMemory_get_counter_value, resolution_ns);

  //SAB_test_resolution_direct(resolution_ns);
}
