#include <emscripten.h>
#include <inttypes.h>
//#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
//#include <sys/stat.h>
//#include <unistd.h>

#include "config.h"
#include "SABcounter.h"
#include "printf_wrapper.h"

// used for SAB_wasmMemory_write_counter_value
uint32_t *SAB_global_counter_buffer = 0;


#define LNEXT(t) (*(void **)(t))

struct timer_info *info;

void counter_consistency_test(int mean, uint32_t counts, uint32_t range)
{
  int sum = 0;
  uint64_t iterations = 0;
  for (uint32_t i = 0; i < counts; i++)
  {
    uint32_t a = SAB_lib_get_counter_value();
    uint32_t b = SAB_lib_get_counter_value();
    iterations++;
    sum += b - a;
    if (!mean)
      printf_ex("%i ", b - a);
    if (i % 1000 == 999)
    {
      if (!mean)
        putchar('\n');
    }
    if (i % range == range - 1)
    {
      if (mean)
        printf_ex("mean last %i: %i, iterations %llu, last counter tick %" PRIu32
               "\n",
               range, sum / range, iterations, b);
      sum = 0;
    }
  }
  SAB_terminate_counter_sub_worker();
  exit(1);
}

float get_timer_resolution()
{
  float resolution_ns = 101;
  while(resolution_ns > 100){
  resolution_ns = SAB_get_resolution_ns(10000);
  }
  printf_ex("resolution SAB-timer: %f ns\n", resolution_ns);
  return resolution_ns;
}

// void print_res(l3pp_t l3, RES_TYPE *res, int nmonitored)
// {
//   printf_ex("size of eviction sets\n");
//   for (int i = 0; i < nmonitored; i++)
//   {
//     vlist_t list = l3->groups[l3->monitoredset[i] / l3->groupsize];
//     printf_ex("%d ", list->len);
//   }
//   printf_ex("\naccess_time for each evictionset per timeslot\n");
//   printf_ex("x-axis eviction-sets, y-axis sample\n");

//   for (int i = 0; i < SAMPLES; i++)
//   {
//     for (int j = 0; j < nmonitored; j++)
//     {
//       printf_ex("%d ", res[i * nmonitored + j]);
//     }
//     if (nmonitored > 0)
//       putchar('\n');
//   }
// }

void SAB_test_resolution(uint32_t (*measure_func)(), float resolution_ns)
{
  for (int i = 0; i < 20; i++)
  {
    uint32_t v1 = (*measure_func)();
    uint32_t v2 = (*measure_func)();
    float diff_ns = (v2 - v1) * resolution_ns;
    printf_ex("%" PRIu32 " (%0.1fns), ", v2 - v1, diff_ns);
  }
  putchar('\n');
}

uint32_t wrapper_SAB_lib_get_counter_value()
{
  return SAB_lib_get_counter_value();
}

uint32_t wrapper_SAB_EM_ASM_get_counter_value()
{
  return EM_ASM_INT({ return Module['sharedArrayCounter'][0]; });
}

uint32_t wrapper_SAB_lib_wasmMemory_get_counter_value()
{
  SAB_lib_wasmMemory_write_counter_value();
  return SAB_global_counter_buffer[0];
}

uint32_t wrapper_SAB_EM_ASM_wasmMemory_get_counter_value()
{
  EM_ASM({
    Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] =
        Module['sharedArrayCounter'][0];
  });
  return SAB_global_counter_buffer[0];
}

uint32_t wrapper_SAB_func_ptr_wasmMemory_get_counter_value()
{
  (*((uint32_t(*)())SAB_func_ptr_write_counter_value()))();
  return SAB_global_counter_buffer[0];
}

uint32_t *wasmMemory_get_buffer(int size)
{
  SAB_global_counter_buffer = (uint32_t *)malloc(sizeof(uint32_t) * size);
  for (int i = 0; i < size; i++)
  {
    SAB_global_counter_buffer[i] = 42;
  }
  // printf("buf add: %#010x\n", (unsigned int)SAB_global_counter_buffer);
  return SAB_global_counter_buffer;
}

uint32_t read_mem(uint32_t *buf)
{
  printf("offset %#010x\n", (unsigned int)buf);
  printf("buf[0]: %" PRIu32 "\n", *buf);
  printf("buf[1]: %" PRIu32 "\n", buf[1]);
  return *buf;
}

void bla(int *buf)
{
  uint32_t before = *SAB_global_counter_buffer;
  doSomething();
  uint32_t after = *SAB_global_counter_buffer;
  uint32_t diff = after - before;
  printf("diff %" PRIu32 "", diff);
}

int doSomething()
{
  int a = 0;
  for (int i = 0; i < 10000; i++)
  {
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

void SAB_bench_call_methods()
{
  float resolution_ns = SAB_get_resolution_ns(100);
  printf("resolution SAB: %f ns\n", resolution_ns);

  printf("call SAB_lib_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_lib_get_counter_value, resolution_ns);

  printf("call SAB_EM_ASM_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_EM_ASM_get_counter_value, resolution_ns);

  printf("call SAB_func_ptr_get_counter_value:\n");
  SAB_test_resolution((uint32_t(*)())SAB_func_ptr_get_counter_value(),
                      resolution_ns);

  SAB_lib_wasmMemory_init_buffer();
  printf("call SAB_lib_wasmMemory_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_lib_wasmMemory_get_counter_value,
                      resolution_ns);

  printf("call SAB_EM_ASM_wasmMemory_get_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_EM_ASM_wasmMemory_get_counter_value,
                      resolution_ns);

  printf("call SAB_func_ptr_write_counter_value:\n");
  SAB_test_resolution(&wrapper_SAB_func_ptr_wasmMemory_get_counter_value,
                      resolution_ns);

  // SAB_test_resolution_direct(resolution_ns);
}
