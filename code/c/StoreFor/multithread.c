#include <time.h>   // for nanosleep
#include <unistd.h> // for usleep
#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
#include <assert.h>
#include <pthread.h>

#include "storefor_find_es.h"


void sleep_ms(int milliseconds) // cross-platform sleep function
{
#ifdef WIN32
    Sleep(milliseconds);
#elif _POSIX_C_SOURCE >= 199309L
    struct timespec ts;
    ts.tv_sec = milliseconds / 1000;
    ts.tv_nsec = (milliseconds % 1000) * 1000000;
    nanosleep(&ts, NULL);
#else
    usleep(milliseconds * 1000);
#endif
}

void sleep_us(int us) // cross-platform sleep function
{
#ifdef _POSIX_C_SOURCE >= 199309L
    struct timespec ts;
    ts.tv_sec = us / 1000*1000;
    ts.tv_nsec = (us % (1000*1000)) * 1000;
    nanosleep(&ts, NULL);
#else
    usleep(us * 1000);
#endif
}

void *thread_spam(void *arg){
    int window_size = *((int*)arg);
    printf("window_size=%i\n",window_size);
	
    uint8_t *pseudoBuffer = (uint8_t*) malloc((window_size+1) * PAGE_SIZE);

	for (;;)
	{
        for(int i = window_size; i >= 0; i--){
            pseudoBuffer[i*PAGE_SIZE] = 0;
        }
	}
}

void measurement_funct_thread(uint8_t * evictionBuffer, int window_size, uint8_t *target_add){
	uint16_t *measurementBuffer = (uint16_t*) malloc(PAGE_COUNT * sizeof(uint16_t));
    //vlist_t es = vl_new();

	for (int p = window_size; p < PAGE_COUNT; p++)
	{
		uint64_t total = 0;
	
		for (int r = 0; r < ROUNDS; r++)		
		{
			// Stores in other trhead
			//sleep_us(10);

			// Measuring load
			// uint32_t tt;
 			// measure(evictionBuffer, &tt);
 			// total += tt;
            evictionBuffer[p*PAGE_SIZE] = 0;
			total += measure_read(evictionBuffer);
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

void thread_attack(int num_of_threads){

    int window_size = 64;
    pthread_t *threads = (pthread_t*)malloc(sizeof(pthread_t)*num_of_threads);

    for(int i = 0; i < num_of_threads; i++)
    {
            //index[i] = i;
            pthread_create(&threads[i], NULL, thread_spam, (void*)&window_size);
    }
    

    uint8_t * evictionBuffer = (uint8_t*) calloc(PAGE_COUNT , PAGE_SIZE);	
    measurement_funct_thread(evictionBuffer, window_size, evictionBuffer);
}

//Intel Architecture Software Optimization manual:

// 2.6.1.2
// Partitioned Resources
// Several buffers are shared by limiting the use of each logical processor to half the entries. These are
// referred to as partitioned resources. Reasons for this partitioning include:

// - Operational fairness.
// - Permitting the ability to allow operations from one logical processor to bypass operations of the other
// logical processor that may have stalled.

// For example: a cache miss, a branch misprediction, or instruction dependencies may prevent a logical
// processor from making forward progress for some number of cycles. The partitioning prevents the stalled
// logical processor from blocking forward progress

// In general, the buffers for staging instructions between major pipe stages are partitioned. These buffers
// include μop queues after the execution trace cache, the queues after the register rename stage, the
// reorder buffer which stages instructions for retirement, and the load and store buffers.