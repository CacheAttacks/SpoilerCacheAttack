#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>
#include <assert.h>

// #include "vlist.h"
// #include "low.h"
// #include "printf_wrapper.h"
#include "storefor_find_es.h"

uint32_t measure_read(void *memory){
    #ifdef WASM
        return memaccesstime(memory, 0);
    #else
		register uint32_t _delta;
        do{
        asm volatile(
        "rdtsc;" //not important, could be rdtsc or rdtscp
        "mov %%eax, %%esi;"
        "mov (%%rbx), %%eax;"

		// make sure load is serialized
		"lfence;"
        "rdtsc;"
		//or
		//"rdtscp;"
		
        //"mfence;" //not important
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

static inline uint64_t rdtscp() {
  uint32_t low, high;
  asm volatile ("rdtscp": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

static inline uint64_t rdtsc() {
  uint32_t low, high;
  asm volatile ("rdtsc": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

int bla(uint32_t *val){
	*val += 1;
	*val += 1;
	*val += 1;
	*val += 1;
}


uint32_t __attribute__((optimize("O0"))) measure_read_alt(void *memory){
	uint32_t before, after, val;
	asm volatile ("rdtsc": "=a" (before) :: "ecx");

	val = *(uint32_t*)memory;
	
	//bla(&val);
	val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
	

	//after = (val & 1) * 3;


	asm volatile ("rdtsc": "=a" (after) :: "ecx");

	return after - before;

// 	  uint32_t a;
//     uint64_t before = rdtscp(), after;
	

//   if (before > 0)
//   {
//     before++;
//     a = *((uint32_t *)memory);
//   }
//   if (a == 0)
//   {
//     after = rdtscp();
//     after++;
//   }
//   else
//   {
//     after = rdtscp();
//     if (before > 0)
//       before--;
//   }
//   return after-before;



}

void measurement_funct(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    //vlist_t es = vl_new();

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
			// uint32_t tt;
 			// measure(evictionBuffer, &tt);
 			// total += tt;
			total += measure_read_alt(evictionBuffer);
		}
		measurementBuffer[p] = total / ROUNDS;

		printf("%u", measurementBuffer[p]);

		total = 0;

		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[(p-i)*PAGE_SIZE] = 0;
			}

			// Measuring load
			// uint32_t tt;
 			// measure(evictionBuffer, &tt);
 			// total += tt;
			total += measure_read(evictionBuffer);
		}
		measurementBuffer[p] = total / ROUNDS;

		 if(measurementBuffer[p] > 300){
		 	printf("%s", KRED);
		 }
		printf("(%u) ", measurementBuffer[p]);
		printf("%s", KNRM);

		//if(measurementBuffer[p-1] < 200 && measurementBuffer[p] > 450)
		//	printf_ex("%i:%p\n", p, evictionBuffer + (p * PAGE_SIZE));
	}

	for(int p = window_size; p < PAGE_COUNT; p++) {
		// if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
		// 	printf("%s", KRED);
			
		// }
			
		// else
		// 	printf("%s", KNRM);
		//printf("%u ", measurementBuffer[p]);
	}
   // printf("\n");
}

void storefor_write(){
	
	// 8MB Buffer
	uint8_t * evictionBuffer;
	evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

	#define WINDOW_SIZE 64

	printf("target_add:%p\n", evictionBuffer);
	measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer);

	// printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	// measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}