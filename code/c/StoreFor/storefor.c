#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>

#include "storefor_find_es.h"
#include "multithread.h"

/**
 * @brief Wrapper for rdtscp
 * 
 * @return uint64_t 
 */
static inline uint64_t rdtscp() {
  uint32_t low, high;
  asm volatile ("rdtsc": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

/**
 * @brief Macro to measure read access time
 * 
 */
#define measure_old(_memory, _time)\
do{\
   register uint32_t _delta;\
   asm volatile(\
   "rdtscp;"\
   "mov %%eax, %%esi;"\
   "mov (%%rbx), %%eax;"\
   "rdtscp;"\
   "mfence;"\
   "sub %%esi, %%eax;"\
   "mov %%eax, %%ecx;"\
   : "=c" (_delta)\
   : "b" (_memory)\
   : "esi", "r11"\
   );\
   *(uint32_t*)(_time) = _delta;\
}while(0)

#define LNEXT(t) (*(void **)(t))

/**
 * @brief Measures access time to read all entries from a ptr-chain
 * 
 * @param pp Begin of the ptr-chain
 * @return uint64_t 
 */
uint64_t probetime(void *pp) {
  if (pp == NULL)
    return 0;
  int rv = 0;
  void *p = (void *)pp;
  uint64_t s = rdtscp();
  do {
    p = LNEXT(p);
  } while (p != (void *) pp);
  return rdtscp()-s;
}

//void dummy(){}

/**
 * @brief Dummy calc method.
 * 
 * @param i 
 * @return int 
 */
int calc(int i){
  return i*3+5-(i*3+5);
}

/**
 * @brief Search for colliding-addresses.
 * 
 * @param evictionBuffer Ptr to buffer. Used for colliding-address search
 * @param window_size Size of isssued store commands
 * @param target_add Not used
 */
void measurement_funct_old(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
	for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
      //dummy();
			for(int i = window_size+1000; i >= 0; i--){
				evictionBuffer[PAGE_SIZE*(i*3+5-(i*3+5))] = i;
			}

			// Measuring load
			uint32_t tt;
			measure_old(evictionBuffer, &tt);
			total += tt;
		}
		measurementBuffer[p] = total / ROUNDS;

		//if(measurementBuffer[p-1] < 200 && measurementBuffer[p] > 450)
		//	printf("%i:%p\n", p, evictionBuffer + (p * PAGE_SIZE));
	}

	for(int p = window_size; p < PAGE_COUNT; p++) {
		if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
			printf("%s", KRED);
			
		}
    if(measurementBuffer[p] > 30){
			printf("%s", KRED);
			
		}
			
		else
			printf("%s", KNRM);
		printf("%u ", measurementBuffer[p]);
	}
}

/**
 * @brief Allocates buffer and starts eviction-set search.
 * 
 */
void storefor_write_old(){
	
	// 8MB Buffer
	uint8_t * evictionBuffer;
	evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

	#define WINDOW_SIZE 64

	printf("target_add:%p\n", evictionBuffer);
	measurement_funct_old(evictionBuffer, WINDOW_SIZE, evictionBuffer);

	//printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	//measurement_funct_old(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}

static inline uint64_t rdtscp64(){
	return rdtscp();
}

int main()
{
	//storefor_write_old();
	//storefor_write();
	
	thread_attack(4);
	
	fgetc(stdin);
}
