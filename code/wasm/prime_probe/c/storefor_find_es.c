#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>
#include <assert.h>
#include <sys/mman.h>

#include "config.h"
#include "low.h"
#include "vlist.h"
#include "SABcounter.h"
#include "l3.h"
#include "printf_wrapper.h"
#include "storefor_find_es.h"
#include "es_management.h"

/**
 * @brief Get mem access time for memory address.
 * 
 * @param v Memory address
 * @return uint32_t 
 */
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

  // for(int i=0; i<10; i++)
  // val*=2;

val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
	//val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;

  after = val;

  after = after + SAB_lib_get_counter_value_storefor();
  //after = SAB_lib_get_counter_value_storefor();

  return after-before-val;
}

/**
 * @brief Get mem access time for memory address.
 * 
 * @param memory Memory address
 * @return uint32_t 
 */
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

/**
 * @brief WASM implementation of colliding address search. Not working! Use js version instead.
 * 
 * @param evictionBuffer 
 * @param window_size 
 * @param target_add 
 */
void measurement_funct(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(STOREFOR_PAGE_COUNT * sizeof(uint16_t));
    uint16_t *measurementBuffer2 = (uint16_t*) malloc(STOREFOR_PAGE_COUNT * sizeof(uint16_t));
    vlist_t es = vl_new();

	for (int p = window_size; p < STOREFOR_PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < STOREFOR_ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[(p-i)*PAGE_SIZE] = 0;
			}
      uint32_t val;
      uint32_t before = SAB_lib_get_counter_value_storefor();
      // for(int i=0; i<100; i++)
      //   before = SAB_lib_get_counter_value_storefor();

      val = *((uint32_t *)evictionBuffer);

      val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;	

      total += SAB_lib_get_counter_value_storefor() -before;

			// Measuring load
			//total += measure_read(evictionBuffer);
		}
		measurementBuffer[p] = total / STOREFOR_ROUNDS;
	}

    for (int p = window_size; p < STOREFOR_PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < STOREFOR_ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[(p-i)*PAGE_SIZE] = 0;
			}
			// Measuring load
			total += measure_read(evictionBuffer);
		}
		measurementBuffer2[p] = total / STOREFOR_ROUNDS;
	}

	for(int p = window_size; p < STOREFOR_PAGE_COUNT; p++) {
        //printf_ex("%u", measurementBuffer[p]);
        printf_ex("%u",  measurementBuffer2[p]);
        if(p < STOREFOR_PAGE_COUNT-1 && measurementBuffer2[p]>measurementBuffer2[p-1]+5 && measurementBuffer2[p+1]>measurementBuffer2[p-1]+5)
          printf_ex("?");
       printf_ex(" ");

		// if(p < STOREFOR_PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
		// 	printf("%s", KRED);
			
		// }
			
		// else
		// 	printf("%s", KNRM);
		//printf_ex("%u ", measurementBuffer[p]);
	}
    printf_ex("\n");
}

/**
 * @brief Wrapper for store_for_js_SAB
 * 
 */
void storefor_write_SAB(){
  uint32_t buffer_size = STOREFOR_PAGE_COUNT * PAGE_SIZE;
  store_for_js_SAB(buffer_size);
}

//variables for debug output
uint64_t time_sum_js = 0, time_sum_wasm = 0;

/**
 * @brief Take buffer from l3 struct and try to create eviction sets. Uses the storeforward leakage
 * 
 * @param l3 Ptr to l3pp struct
 * @return int 
 */
int probemap_storeforwardleakage(void *app_state_ptr){
    struct app_state *this_app_state = (struct app_state *)app_state_ptr;
    l3pp_t l3 = this_app_state->l3;

    uint32_t timer_before = get_time_in_ms();

    l3->collect_groups = vl_new();

    int window_size = this_app_state->storefor_window_size;
    int rounds = this_app_state->storefor_rounds;
    int threshold_search_for_es = this_app_state->storefor_threshold_search_for_es;
    int number_of_searches = this_app_state->l3_cache_sets / this_app_state->l3_cache_slices / this_app_state->l3_cache_line_size;

    int failed = 0;
    uint32_t buffer_size = l3->l3info.bufsize;

    uint32_t storefor_add_arr_size = threshold_search_for_es+1;
    uint8_t * storefor_add_arr = (uint8_t*) calloc(sizeof(uint32_t), storefor_add_arr_size);	
    printf_ex("storefor_write buffer size: %i MiB\n", buffer_size/1024/1024);

    //printf_ex("target_add:%p\n", buffer);
    
    //wasm version measurement_funct not working. Use js version store_for_js instead.
    //measurement_funct(l3->buffer, WINDOW_SIZE, l3->buffer);

    printf_ex("number_of_searches:%i, STOREFOR_MAX_ITERATIONS:%i\n", number_of_searches, STOREFOR_MAX_ITERATIONS);
    for(int i = 0; i < number_of_searches; i++){
      for(int j = 0; j < STOREFOR_MAX_ITERATIONS; j++){
        //assumes that the least 20 physical address bits for address l3->buffer+i*PAGE_SIZE (i from 0 to 31) are different
        //can test this by measuring the prob for a colliding address occuring in any of the next 31 addresses (address+i*PAGE_SIZE with i from 1 to 31)
        //tests shows a low prob for this problem, therefore the addresspool is not filtered after each iteration
        if(store_for_js((WASMPTR)l3->buffer, buffer_size, (WASMPTR)storefor_add_arr, storefor_add_arr_size, (WASMPTR)(l3->buffer+i*PAGE_SIZE), threshold_search_for_es, window_size, rounds, (WASMPTR)l3)){
          //printf_ex("success!\n");
          failed = 0;
          break;
        }
        failed = 1;
      }
      if(failed){
        printf_ex("es serach failed!\n");
        break;
      }
    }

    // Store map results
    l3->ngroups = vl_len(l3->collect_groups);
    l3->groups = (vlist_t *)calloc(l3->ngroups, sizeof(vlist_t));
    for (int i = 0; i < vl_len(l3->collect_groups); i++)
      l3->groups[i] = vl_get(l3->collect_groups, i);

    vl_free(l3->collect_groups);

    uint32_t timer_after = get_time_in_ms();

    uint64_t time_sum = time_sum_js + time_sum_wasm;
    
    if(!failed){
      printf_ex("half increments\n");
      printf_ex("rounds:%i\n", rounds);
      printf_ex("window_size:%i\n", window_size);
      printf_ex("threshold_search_for_es:%i\n", threshold_search_for_es);
      printf_ex("time StoreFor:%u\n", (timer_after - timer_before) / 1000);
      printf_ex("time sum js:%f\n", (double)time_sum_js / time_sum);
      printf_ex("time sum wasm:%f\n", (double)time_sum_wasm / time_sum);
      printf_ex("max additional colliding addresses:%f\n", storefor_add_arr_size-threshold_search_for_es);
    } else {
      printf_ex("----------------------------------------\n");
      printf_ex("---------------FAILED-------------------\n");
      printf_ex("----------------------------------------\n");
      return 0;
    }

    time_sum_wasm = 0;
    time_sum_js = 0;

    return 1;
}

/**
 * @brief Only used for storeforward benchmarks and additional tests!
 * 
 * @param app_state_ptr Ptr to app state struct
 * @param benchmarkruns Number of benchmarks runs
 */
void storefor_write(void *app_state_ptr, int benchmarkruns){
  //test if allocated buffer is continous physical memory (speed eviction set search by a factor of 2^8)
	
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

	// 8MB Buffer
	// uint8_t * evictionBuffer;
	// evictionBuffer = (uint8_t*) malloc(STOREFOR_PAGE_COUNT * PAGE_SIZE);
	// memset(evictionBuffer, 0, STOREFOR_PAGE_COUNT * PAGE_SIZE);	

  while(benchmarkruns){

    uint32_t timer_before = get_time_in_ms();

    uint32_t buffer_size = STOREFOR_BUFFER_SIZE;
    uint8_t* buffer = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,
                    -1, 0);
    printf_ex("storefor_write buffer size: %i MiB\n", buffer_size/1024/1024);

    uint32_t storefor_add_arr_size = 116;
    uint8_t * storefor_add_arr = (uint8_t*) calloc(sizeof(uint32_t), storefor_add_arr_size);	

    int WINDOW_SIZE = 60;
    int rounds = 20;
    int threadholdSearchForEs = 115;

    l3pp_t l3 = l3_create_only(app_state_ptr, 31, 5, buffer_size);
    this_app_state->l3 = l3;
    int failed = 0;
    l3->collect_groups = vl_new();

    //printf_ex("target_add:%p\n", buffer);
    measurement_funct(buffer, WINDOW_SIZE, buffer);
    exit(1);

    for(int i=0; i<32; i++){
      for(int j=0; j<10; j++){
        if(store_for_js((WASMPTR)buffer, buffer_size, (WASMPTR)storefor_add_arr, storefor_add_arr_size, (WASMPTR)(buffer+i*PAGE_SIZE), threadholdSearchForEs, WINDOW_SIZE, rounds, (WASMPTR)this_app_state->l3)){
          //printf_ex("success!\n");
          failed = 0;
          break;
        }
        failed = 1;
      }
      if(failed){
        break;
      }
    }

    // Store map results
    l3->ngroups = vl_len(l3->collect_groups);
    l3->groups = (vlist_t *)calloc(l3->ngroups, sizeof(vlist_t));
    for (int i = 0; i < vl_len(l3->collect_groups); i++)
      l3->groups[i] = vl_get(l3->collect_groups, i);

    vl_free(l3->collect_groups);

    uint32_t timer_after = get_time_in_ms();

    uint64_t time_sum = time_sum_js + time_sum_wasm;
    
    if(!failed){
      printf_ex("half increments\n");
      printf_ex("rounds:%i\n", rounds);
      printf_ex("windowSize:%i\n", WINDOW_SIZE);
      printf_ex("threadholdSearchForEs:%i\n", threadholdSearchForEs);
      printf_ex("time StoreFor:%u\n", (timer_after - timer_before) / 1000);
      printf_ex("time sum js:%f\n", (double)time_sum_js / time_sum);
      printf_ex("time sum wasm:%f\n", (double)time_sum_wasm / time_sum);
      printf_ex("max additional colliding addresses:%f\n", storefor_add_arr_size-threadholdSearchForEs);
    } else {
      printf_ex("----------------------------------------\n");
      printf_ex("---------------FAILED-------------------\n");
      printf_ex("----------------------------------------\n");
    }

    time_sum_wasm = 0;
    time_sum_js = 0;

    if(benchmarkruns){
      benchmarkruns--;
      munmap(buffer, buffer_size);
      l3_release(l3);
    }
  }

  //store_for_js((uint32_t)buffer, bufsize);
  //store_for_js((uint32_t)buffer, bufsize);


	// printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	// measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}


//#define DEBUG_OUTPUT_COLLIDING_ADDRESS_DIST //output distance between colliding addresses

/**
 * @brief Tries to create an es from a pool of colliding-addresses (least 20 bit of each address are identical).
 * Uses the standard eviction-set search method to find the es.
 * 
 * @param address_arr Ptr to array with the colliding addresses (filled by js)
 * @param number_of_storefor_add Number of colliding addresses
 * @param startTime Start time of the colliding address search (for debug purposes)
 * @param endTime End time of the colliding address search (for debug purposes)
 * @param ptr_l3 Ptr to l3 struct
 * @return int 
 */
int try_to_create_es(uint32_t *address_arr, uint32_t number_of_storefor_add, uint32_t startTime, uint32_t endTime, void* ptr_l3){
  l3pp_t l3 = (l3pp_t)ptr_l3;
  time_sum_js += (uint64_t)get_diff(startTime, endTime);
  
  uint32_t startTimeWasm = rdtscp();
  vlist_t lines = vl_new();

#ifdef DEBUG_OUTPUT_COLLIDING_ADDRESS_DIST
  int opt_counter = 0, max_opt=0, opt_sum =0;
#endif

  for(int i=0; i<number_of_storefor_add; i++){

#ifdef DEBUG_OUTPUT_COLLIDING_ADDRESS_DIST
    if(i>1){
      printf_ex("%i ", (address_arr[i]-address_arr[i-1])/4096);
      if((address_arr[i]-address_arr[i-1])/4096 == 256){
        opt_counter++;
        opt_sum++;
      }
      else { 
        if(opt_counter > max_opt){
          max_opt = opt_counter;
        }
        opt_counter = 0;
      }
    }
#endif
    vl_push(lines, (void*)(address_arr[i]+2048));
  }


#ifdef DEBUG_OUTPUT_COLLIDING_ADDRESS_DIST
  printf_ex("max_opt:%i, opt_sum:%i\n", max_opt, opt_sum);
#endif

  vlist_t groups = map(l3, lines, 0);
  //vl_free(lines);

  time_sum_wasm += (uint64_t)get_diff(startTimeWasm, rdtscp());

  //number of found es should be equal with L3_CACHE_SLICES!
  if(vl_len(groups) == L3_CACHE_SLICES){
    vlist_t es = vl_get(groups, 0);

    //for(int i=0; i<vl_len(es); i++){
      //printf_ex("%p ",vl_get(es,i));
    //}
    //printf_ex("\n");

    vlist_t expanded_groups = expand_groups(groups);
    vl_free(groups);
    while(vl_len(expanded_groups) > 0){
      vl_push(l3->collect_groups, vl_pop(expanded_groups));
    }
    vl_free(expanded_groups);
    return 1;
  }
  vl_free(groups);  
  return 0;
}