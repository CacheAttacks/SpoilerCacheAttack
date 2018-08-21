#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <time.h>

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

#define ROUNDS 100		// For averaging the timings
#define PAGE_COUNT 1024*4
#define PAGE_SIZE 4096

static inline uint64_t rdtscp() {
  uint32_t low, high;
  asm volatile ("rdtsc": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

#define measure(_memory, _time)\
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

void measurement_funct(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
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
			uint32_t tt;
			measure(evictionBuffer, &tt);
			total += tt;
		}
		measurementBuffer[p] = total / ROUNDS;

		if(measurementBuffer[p-1] < 200 && measurementBuffer[p] > 450)
			printf("%i:%p\n", p, evictionBuffer + (p * PAGE_SIZE));
	}

	for(int p = window_size; p < PAGE_COUNT; p++) {
		if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130){
			printf("%s", KRED);
			
		}
			
		else
			printf("%s", KNRM);
		//printf("%u ", measurementBuffer[p]);
	}
}

void storefor_write(){
	
	// 8MB Buffer
	uint8_t * evictionBuffer;
	evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);	

	#define WINDOW_SIZE 64

	printf("target_add:%p\n", evictionBuffer);
	measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer);

	printf("target_add:%p\n", evictionBuffer+PAGE_SIZE);
	measurement_funct(evictionBuffer, WINDOW_SIZE, evictionBuffer+PAGE_SIZE);
}

static inline uint64_t rdtscp64(){
	return rdtscp();
}

#define measurewrite(_memory, _time)\
do{\
   register uint32_t _delta;\
   asm volatile(\
   "rdtscp;"\
   "mov %%eax, %%esi;"\
   "mov %%eax, (%%rbx);"\
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

#define read(_memory)\
do{\
   register uint32_t _delta;\
   asm volatile(\
   "mov (%%rbx), %%eax;"\
   : \
   : "b" (_memory)\
   : "r11"\
   );\
}while(0)

void storefor_read(){
	uint32_t tt;
	uint64_t total = 0;
	
	// 8MB Buffer
	uint8_t * evictionBuffer;
	evictionBuffer = (uint8_t*) malloc(PAGE_COUNT * PAGE_SIZE);
	memset(evictionBuffer, 0, PAGE_COUNT * PAGE_SIZE);
	uint16_t * measurementBuffer;
	measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));

	#define WINDOW 40

	for (int p = WINDOW; p < PAGE_COUNT; p++)
	{
		total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores
			for(int i = WINDOW; i >= 0; i--){
				read(evictionBuffer + ((p-i) * PAGE_SIZE));
			}

			// Measuring load
			uint64_t t1 = rdtscp64();
			evictionBuffer[0] = 1;
			//measurewrite(evictionBuffer, &tt);
			total += rdtscp64() - t1;

		}
		measurementBuffer[p] = total / ROUNDS;
	}

	for(int p = WINDOW; p < PAGE_COUNT; p++) {
		if(p < PAGE_COUNT-1 && measurementBuffer[p] > 150 && measurementBuffer[p+1] > 130)
			printf("%s", KRED);
		else
			printf("%s", KNRM);
		printf("%u ", measurementBuffer[p]);

	}
}


int main()
{
	storefor_write();
	//storefor_read();
	
	fgetc(stdin);
}
