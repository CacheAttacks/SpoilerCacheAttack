#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* calloc, exit, free */
#include <stdint.h>
#include <signal.h>
#include <inttypes.h>
#include <iostream>       // std::cout
#include <atomic>         // std::atomic, std::atomic_flag, ATOMIC_FLAG_INIT
#include <thread>         // std::thread, std::this_thread::yield
#include <vector>         // std::vector

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

int main ()
{
  //no clear difference between PTR_OFFSET 1 and 4
  first_test();


  //second_test();


  int p;
  scanf ("%d",&p);
  return 0;
}
