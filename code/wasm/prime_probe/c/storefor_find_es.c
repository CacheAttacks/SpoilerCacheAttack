#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>
#include <assert.h>

#include "config.h"
#include "vlist.h"
#include "SABcounter.h"
#include "printf_wrapper.h"
#include "storefor_find_es.h"

static inline void warmuptimer()
{
  while (1)
  {
    uint32_t before = SAB_lib_get_counter_value();
    uint32_t after = SAB_lib_get_counter_value();
    if (after - before > 0 && after - before < 100)
    {
      break;
    }
  }
}

static inline uint32_t memaccesstime(void *v)
{
    warmuptimer();
  uint32_t a;
  uint32_t after;
  uint32_t before = SAB_lib_get_counter_value();
  if (before > 0)
  {
    before++;
    a = *((uint32_t *)v);
    a = read_mem_ptr((uint32_t)v);
  }
  if (a == 0)
  {
    after = SAB_lib_get_counter_value();
    after++;
  }
  else
  {
    after = SAB_lib_get_counter_value();
    if (before > 0)
      before--;
  }
  return after-before;
}


uint32_t measure_read(void *memory){
    //printf_ex("%p\n", memory);
    #ifdef WASM
        return memaccesstime(memory);
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
			// Measuring load
			total += measure_read(evictionBuffer);
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
        printf_ex("%u(%u) ", measurementBuffer[p], measurementBuffer2[p]);

		// if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
		// 	printf("%s", KRED);
			
		// }
			
		// else
		// 	printf("%s", KNRM);
		//printf_ex("%u ", measurementBuffer[p]);
	}
    printf_ex("\n");

}

void storefor_write(){
	
	// 8MB Buffer
	uint8_t * evictionBuffer;
	evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

	#define WINDOW_SIZE 64

	printf_ex("target_add:%p\n", evictionBuffer);
	measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer);

	// printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	// measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}