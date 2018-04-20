#include "SABcounter.h"

void SAB_test_resolution(int (*measure_func)(), float resolution_ns){
  for(int i = 0; i< 20; i++) {
    int v1 = (*measure_func)();
    int v2 = (*measure_func)();
    float diff_ns = (v2-v1)*resolution_ns;
    printf("%i(%0.1fns), ", v2-v1, diff_ns);
  }
  putchar('\n');
}

int wrapper_SAB_lib_get_counter_value(){
  return SAB_lib_get_counter_value();
}

int wrapper_SAB_EM_ASM_get_counter_value(){
  return EM_ASM_INT({
    return Module['sharedArrayCounter'][0];
  });
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

  printf("call get_counter_value_SAB_lib:\n");
  SAB_test_resolution(&wrapper_SAB_lib_get_counter_value, resolution_ns);

  printf("call get_counter_value_SAB_EM_ASM:\n");
  SAB_test_resolution(&wrapper_SAB_EM_ASM_get_counter_value, resolution_ns);

  int (*SAB_func_ptr)() = (int (*)())SAB_func_ptr_get_counter_value();
  printf("call javascript_func_ptr_measurement:\n");
  SAB_test_resolution(SAB_func_ptr, resolution_ns);



  //SAB_test_resolution_direct(resolution_ns);
}
