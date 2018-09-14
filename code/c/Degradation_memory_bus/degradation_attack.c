#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* calloc, exit, free */
#include <stdint.h>
#include <signal.h>
#include <inttypes.h>
#include <iostream>       // std::cout
#include <atomic>         // std::atomic, std::atomic_flag, ATOMIC_FLAG_INIT
#include <thread>         // std::thread, std::this_thread::yield
#include <vector>         // std::vector
#include <pthread.h>

#define PAGE_SIZE 4096
#define PAGE_COUNT 16

#define ATOMIC_TYPE sig_atomic_t
#define BUFFER_SIZE PAGE_SIZE * PAGE_COUNT

//#define PTR_OFFSET 1


static inline uint64_t rdtscp64() {
  uint32_t low, high;
  asm volatile ("rdtscp": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

static inline uint32_t rdtscp32() {
  uint32_t timer;
  asm volatile ("rdtscp": "=a" (timer) :: "ecx");
  return timer;
}

void first_test_sub(int PTR_OFFSET, uint8_t* pData){
  uint32_t t1,t2;
  uint32_t *times = (uint32_t*)calloc(BUFFER_SIZE / PTR_OFFSET,sizeof(uint32_t));
  for (int i=0; i < BUFFER_SIZE / PTR_OFFSET; i++)
  {
    t1 = rdtscp32();
    ATOMIC_TYPE value = *((ATOMIC_TYPE*)(pData + i * PTR_OFFSET));
    times[i] = rdtscp32()-t1;
  }
  for (int i=0; i < BUFFER_SIZE / PTR_OFFSET; i++)
    if(100<times[i] )
        printf("%i:%" PRIu32 "\n", i, times[i]);
  free(times);
}

void first_test(){
  printf("sizeof(ATOMIC_TYPE):%i\n", (int)sizeof(ATOMIC_TYPE));
  uint32_t t1,t2;

  uint8_t *pData = (uint8_t*) calloc (BUFFER_SIZE,1);

  first_test_sub(1, pData);     
  first_test_sub(4, pData);
  first_test_sub(3, pData);

  free (pData);
}

void second_test(){
  //uint8_t *pData = (uint8_t*) calloc (BUFFER_SIZE,1);
  //std::atomic<int*> atomic_arr = (int*)pData;
  uint32_t *times = (uint32_t*)calloc(BUFFER_SIZE,sizeof(uint32_t));

  std::array<std::atomic<int>, BUFFER_SIZE> array={};
  uint32_t t1,t2;
  for (int i=0; i < BUFFER_SIZE; i++)
  {
    t1 = rdtscp32();
    int value = array[i];
    t2 = rdtscp32();
  }
    for (int i=0; i < BUFFER_SIZE; i++)
  {
    t1 = rdtscp32();
    int value = array[i];
    times[i] = rdtscp32()-t1;
  }
  for(int i=0; i< BUFFER_SIZE; i++)
    if(100<times[i] )
        printf("%i:%" PRIu32 "\n", i, times[i]);
}

#define N 10000

void risenpart_loop(char *unaligned_addr){
  uint32_t *times = (uint32_t*)calloc(N,sizeof(uint32_t));
    //loop i from (1..N):
  for(int i=0; i<N; i++){
    uint32_t t1 = rdtscp32();
    //printf("%i ", i);

    //atomic_op(unaligned_addr + i, some_value)
    asm volatile (
      "xchg (%[unaligned_addr]), %%ecx;"
    : //output
    : [unaligned_addr] "a"(unaligned_addr + i) //input
    : "ecx" // clobbered register
    ); 

    times[i] = rdtscp32()-t1;
  }
  // for(int i=0; i<N; i++){
  //   if(times[i] > 1500){
  //     printf("%i:%" PRIu32 "\n", i, times[i]);
  //   }
  // }
  free(times);
}

static void* measure_risepart(void*){
  int LLC_size = 8*1024*1024, LLC_ways = 16, LLC_sets = 8192, cacheline_sz = 64;
  int size = LLC_size * (LLC_ways +1);
  int stride = LLC_sets * cacheline_sz;
  //char* buffer = alloc_ptr_chasing_buff(size, stride)
  char* buffer = (char*)calloc(LLC_size,1);
  uint32_t *time_taken = (uint32_t*)calloc(BUFFER_SIZE,sizeof(uint32_t));

  //loop sample from (1..10): //number of samples
  for(int sample=0; sample< 10; sample++){
    uint32_t start_rdtsc = rdtscp32();
    //loop probes from (1..10000):
    for(int i=0; i< LLC_size; i++){
      buffer[i]++;
    }
    time_taken[sample] = (rdtscp32() - start_rdtsc);
    printf("%i:%" PRIu32 "\n",sample, time_taken[sample]);
  }
  for(int i=0; i< 10; i++){
    
  }
}

void test_risenpart(){
  // allocate memory multiples of 64 bits
  // char_ptr = allocate_memory((N+1)*8)
  char* char_ptr = (char*)calloc((N+1)*8,1);

  //move half word up
  //unaligned_addr = char_ptr + 2
  char *unaligned_addr = char_ptr + 2;

  pthread_t thread1;
  int rc = pthread_create( &thread1, NULL, &measure_risepart, NULL );                  

  for(int i=0; i<100; i++){
    risenpart_loop(unaligned_addr);
    if(i%10==9)
      printf("10 finished\n");
  }
}



int main ()
{
  //no clear difference between PTR_OFFSET 1 and 4
  //first_test();

  test_risenpart();


  //second_test();


  int p;
  scanf ("%d",&p);
  return 0;
}
