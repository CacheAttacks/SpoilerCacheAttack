#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* calloc, exit, free */
#include <stdint.h>
#include <signal.h>
#include <inttypes.h>
#include <iostream>       // std::cout
#include <thread>         // std::thread, std::this_thread::yield
#include <vector>         // std::vector
#include <pthread.h>
#include <time.h>   // for nanosleep
#include <unistd.h> // for usleep

static inline uint64_t rdtscp64() {
  uint32_t low, high;
  asm volatile ("rdtscp": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

void* while_1(void*){
  while(1){for(int j=0; j<1000*1000*1000; j++){}}
}

void* multithread_slow(void* arg_max_threads){
    int max_threads = *((int*)arg_max_threads);
    pthread_t *threads = (pthread_t*)malloc(sizeof(pthread_t) * max_threads);

    for(int i = 0; i < max_threads; i++){
            printf("create thread %i\n", i+1);
            pthread_create(&threads[i], NULL, while_1, NULL);
            sleep(4);
    }
}

int main ()
{
    int max_threads = 3;
    //pthread_t thread;
    //pthread_create(&thread, NULL, multithread_slow, (void*)&max_threads);

    pthread_t *threads = (pthread_t*)malloc(sizeof(pthread_t) * max_threads);

    for(int i=0 ;i<max_threads; i++){
        printf("create thread %i\n", i+1);
        pthread_create(&threads[i], NULL, while_1, NULL);
        uint64_t start = rdtscp64();
        //for(int j=0; j<1000*1000*1000; j++){}
        printf("%" PRIu64 "\n" , rdtscp64()- start);
    }
    int p;
    scanf ("%d",&p);
}
