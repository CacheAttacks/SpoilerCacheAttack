#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>
#include <assert.h>
#include <sys/mman.h>

#include "low.h"
#include "vlist.h"
#include "SABcounter.h"
#include "l3.h"
#include "printf_wrapper.h"
#include "storefor_find_es.h"
#include "es_management.h"

// static inline uint32_t memaccesstime(void *v)
// {
//     warmuptimer();
//   uint32_t a;
//   uint32_t after;
//   uint32_t before = SAB_lib_get_counter_value();
//   if (before > 0)
//   {
//     before++;
//     a = *((uint32_t *)v);
//     a = read_mem_ptr((uint32_t)v);
//   }
//   if (a == 0)
//   {
//     after = SAB_lib_get_counter_value();
//     after++;
//   }
//   else
//   {
//     after = SAB_lib_get_counter_value();
//     if (before > 0)
//       before--;
//   }
//   return after-before;
// }

__attribute__((optnone))
static inline uint32_t memaccesstime_alt(void *v)
{
    warmuptimer();
  volatile uint32_t val;
  uint32_t after;
  uint32_t before = SAB_lib_get_counter_value_storefor();
  for(int i=0; i<100; i++)
    before = SAB_lib_get_counter_value_storefor();

  val = *((uint32_t *)v);

  for(int i=0; i<10; i++)
  val*=2;

	//val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;

  after = val;

  after = after + SAB_lib_get_counter_value_storefor();
  //after = SAB_lib_get_counter_value_storefor();

  return after-before-val;
}


uint32_t measure_read(void *memory){
    //printf_ex("%p\n", memory);
    #ifdef WASM
        return memaccesstime_alt(memory);
    #else
		register uint32_t _delta;
        do{
        asm volatile(
        "rdtscp;"
        "mov %%eax, %%esi;"
        "mov (%%rbx), %%eax;"
        "rdtscp;"
        "mfence;"
        "sub %%esi, %%eax;"
        "mov %%eax, %%ecx;"
        : "=c" (_delta)
        : "b" (memory)
        : "esi", "r11"
        );
        }while(0);
        return _delta;
    #endif
}

void measurement_funct(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    uint16_t *measurementBuffer2 = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    vlist_t es = vl_new();

	for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[(p-i)*PAGE_SIZE] = 0;
			}
      uint32_t val;
      uint32_t before = SAB_lib_get_counter_value_storefor();
      for(int i=0; i<100; i++)
        before = SAB_lib_get_counter_value_storefor();

      val = *((uint32_t *)evictionBuffer);

      val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	

      total += SAB_lib_get_counter_value_storefor() -before;

			// Measuring load
			//total += measure_read(evictionBuffer);
		}
		measurementBuffer[p] = total / ROUNDS;
	}

    for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[(p-i)*PAGE_SIZE] = 0;
			}
			// Measuring load
			total += measure_read(evictionBuffer);
		}
		measurementBuffer2[p] = total / ROUNDS;
	}

	for(int p = window_size; p < PAGE_COUNT; p++) {
        printf_ex("%u ", measurementBuffer[p]);
        printf_ex("(%u)",  measurementBuffer2[p]);
       printf_ex(" ");

		// if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
		// 	printf("%s", KRED);
			
		// }
			
		// else
		// 	printf("%s", KNRM);
		//printf_ex("%u ", measurementBuffer[p]);
	}
    printf_ex("\n");

}

  l3pp_t l3 ;

void storefor_write_SAB(){
  uint32_t buffer_size = PAGE_COUNT * PAGE_SIZE;
  store_for_js_SAB(buffer_size);
}

uint64_t time_sum_js = 0, time_sum_wasm = 0;

void storefor_write(int benchmarkruns){
  //test if allocated buffer is continous physical memory (speed eviction set search by a factor of 2^8)
	
	// 8MB Buffer
	// uint8_t * evictionBuffer;
	// evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	// memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

  while(benchmarkruns){

    uint32_t timer_before = get_time_in_ms();

    uint32_t buffer_size = PAGE_COUNT * PAGE_SIZE;
    uint8_t* buffer = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,
                    -1, 0);

    uint32_t storefor_add_arr_size = 120;
    uint8_t * storefor_add_arr = (uint8_t*) malloc(sizeof(uint32_t) * storefor_add_arr_size);
    memset(storefor_add_arr, 0, sizeof(uint32_t) * storefor_add_arr_size);	

    int WINDOW_SIZE = 50;
    int rounds = 20;
    int threadholdSearchForEs = 115;

    l3 = l3_create_only(31, 5, buffer_size);
    int failed = 0;

    //printf_ex("target_add:%p\n", buffer);
    //measurement_funct(buffer, WINDOW_SIZE, buffer);
    for(int i=0; i<32; i++){
      for(int j=0; j<3; j++){
        if(store_for_js((uint32_t)buffer, buffer_size, (uint32_t)storefor_add_arr, storefor_add_arr_size, (uint32_t)(buffer+i*PAGE_SIZE), threadholdSearchForEs, WINDOW_SIZE, rounds)){
          break;
        }
        failed = 1;
        printf_ex("failed\n");
      }
      if(failed){
        break;
      }
    }

    uint32_t timer_after = get_time_in_ms();

    uint64_t time_sum = time_sum_js + time_sum_wasm;
    
    if(!failed){
      printf_ex("rounds:%i\n", rounds);
      printf_ex("windowSize:%i\n", WINDOW_SIZE);
      printf_ex("threadholdSearchForEs:%i\n", threadholdSearchForEs);
      printf_ex("time StoreFor:%u\n", (timer_after - timer_before) / 1000);
      printf_ex("time sum js:%f\n", (double)time_sum_js / time_sum);
      printf_ex("time sum wasm:%f\n", (double)time_sum_wasm / time_sum);
    }

    time_sum_wasm = 0;
    time_sum_js = 0;

    if(benchmarkruns){
      munmap(buffer, buffer_size);
      l3_release(l3);
      benchmarkruns--;
    }
  }

  //store_for_js((uint32_t)buffer, bufsize);
  //store_for_js((uint32_t)buffer, bufsize);


	// printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	// measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}

int try_to_create_es(uint32_t *address_arr, uint32_t number_of_storefor_add, uint32_t startTime, uint32_t endTime){
  time_sum_js += (uint64_t)get_diff(startTime, endTime);
  
  uint32_t startTimeWasm = rdtscp();
  vlist_t lines = vl_new();
  int opt_counter = 0, max_opt=0, opt_sum =0;
  for(int i=0; i<number_of_storefor_add; i++){
    // if(i>1){
    //   printf_ex("%i ", (address_arr[i]-address_arr[i-1])/4096);
    //   if((address_arr[i]-address_arr[i-1])/4096 == 256){
    //     opt_counter++;
    //     opt_sum++;
    //   }
    //   else { 
    //     if(opt_counter > max_opt){
    //       max_opt = opt_counter;
    //     }
    //     opt_counter = 0;
    //   }
    // }
    vl_push(lines, (void*)(address_arr[i]+2048));
  }
  //printf_ex("max_opt:%i, opt_sum:%i", max_opt, opt_sum);
  //printf_ex("\n");
  //vl_free(lines);

  vlist_t groups = map(l3, lines, 0);
  //printf_ex("%i\n",vl_len(lines));
  //groups = map(l3, lines);
  //groups = map(l3, lines);
  //groups = map(l3, lines);

  time_sum_wasm += (uint64_t)get_diff(startTimeWasm, rdtscp());

  if(vl_len(groups) == 4){
    vlist_t es = vl_get(groups, 0);
    for(int i=0; i<vl_len(es); i++){
      //printf_ex("%p ",vl_get(es,i));
    }
    //printf_ex("\n");
    return 1;
  }
    
  return 0;
}