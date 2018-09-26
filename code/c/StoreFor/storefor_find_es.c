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
        "rdtscp;" //not important, could be rdtsc or rdtscp
        "mov %%eax, %%esi;"
        "mov (%%rbx), %%eax;"

		// make sure load is serialized
		"lfence;"
        "rdtscp;"
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

void dummy(){}

int permutation65[] = {29, 24, 4, 42, 21, 23, 10, 28, 53, 20, 1, 61, 51, 54, 33, 9, 36, 49, 19, 41, 44, 13, 6, 26, 55, 57, 46, 52, 62, 34, 65, 12, 11, 15, 16, 35, 43, 3, 50, 58, 38, 47, 64, 48, 22, 31, 17, 60, 56, 18, 27, 8, 14, 30, 59, 5, 37, 45, 63, 39, 32, 25, 40, 2, 7};

int rand65[] = {1578, 2912, 2738, 399, 2965, 1070, 3108, 1865, 425, 1370, 3792, 1917, 3061, 3876, 1205, 2294, 280, 3113, 1022, 1754, 1834, 3066, 4069, 2985, 941, 3854, 15, 757, 995, 2235, 1087, 495, 3231, 18, 1126, 3218, 3789, 112, 1809, 1114, 2272, 1773, 3255, 1913, 380, 2623, 1991, 2, 2548, 316, 1171, 3749, 440, 3121, 1555, 2754, 1949, 685, 2162, 1536, 3491, 969, 3547, 3806, 884};

void measurement_funct(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    //vlist_t es = vl_new();

	uint8_t *pseudoBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(pseudoBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

	for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			dummy();
			//zwischen auf und absteigend (i++ und i--) wie erawrtet kein unterschied
			for(int i = 0; i <= 7; i++){
			//for(int i = window_size; i >= 0; i--){

				//need to be a multiple of at least 1024
				//wenn mit (p-i) dann auch mit permutation65[i]

				//evictionBuffer[p*PAGE_SIZE] = 0; //geht nicht
				//pseudoBuffer[(p-i)*1024] = 0; //geht 0b10000000000
				//pseudoBuffer[(p-i)*1023] = 0; //geht 0b1111111111
				//pseudoBuffer[(p-i)*512] = 0; //geht nicht 0b1000000000
				//pseudoBuffer[(p-i)*1022] = 0;//geht ein bisschen 0b1111111110
				//pseudoBuffer[1024] = 0; //geht nicht
				//pseudoBuffer[0] = 0; //geht nicht
				//pseudoBuffer[permutation65[i]*1024] = 0; //geht
				//pseudoBuffer[permutation65[i]*512] = 0; // geht nicht
				//pseudoBuffer[permutation65[i]*2834] = 0; // geht nicht 0b101100010010
				
				//bit 12-63 sind relevant, da
				//pseudoBuffer[rand65[i]*1023] geht nicht 0b1111111111
				//pseudoBuffer[rand65[i]*1024] geht 0b10000000000

				//pseudoBuffer[(p-i)*1023] = 0; peaks deutlich ausgeprägter als bei pseudoBuffer[i*1023] = 0;

				//Bei pseudoBuffer[(i)*4096] = 0; reichen 8 bis 9 Schreibzugriffe aus (=Schleifen-Iterationen)

				//pseudoBuffer[(p-i)*0b1111111111] höherer Auschlaga als bei pseudoBuffer[i*0b1111111111]

				//0b111111111110 geht
				//0b111111111101 geht
				//0b111111111011 geht
				//0b111111110111 geht nicht
				//0b111111101111 geht nicht

				//0b111111111000 geht nicht
				//0b111111111001 geht nicht

				pseudoBuffer[(i)*4096] = 0;
			}
			//access to possible colliding address is necessary
			evictionBuffer[p*PAGE_SIZE] = 0;

			// Measuring load
			// uint32_t tt;
 			// measure(evictionBuffer, &tt);
 			// total += tt;
			total += measure_read(evictionBuffer);
			//total += measure_read_alt(evictionBuffer);
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
   	free(pseudoBuffer);
}

void measurement_funct_alt(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    //vlist_t es = vl_new();

	for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			for(int i = window_size; i >= 0; i--){
				evictionBuffer[0] = 0;
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