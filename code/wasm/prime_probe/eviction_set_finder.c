#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <inttypes.h>

//#include <util.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "SABcounter.h"

#define BLOCK_SIZE 8
#define SAMPLES 1000
#define LNEXT(t) (*(void **)(t))


//TODO fix ideen:
//random zugriff auf es oder rückwärts durchlauf
//debug ausgaben von zeiten
//debug adresse von rausgeworfenen add aus es
//change add offset

int test_mem_access(int random, int rounds, int print)
{
  int pages = 1024*1024*20;
  int bufsize = BLOCK_SIZE*pages;
  if(bufsize > 1024*1024*200){
    printf("bufsize to big!");
    exit(1);
  }
  char *buffer = mmap(NULL, bufsize, PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE, -1, 0);
  //char *buffer = (char*)calloc(bufsize,1);
  flush_l3(buffer, pages, BLOCK_SIZE);
  srand(32);   // should only be called once
  void *randomPtr;
  int randomIndex;
  int sum = 0;
  int flush = 0;
  uint32_t *counter = malloc(sizeof(uint32_t) * rounds * 4);
  for(int i=0; i<rounds; i++)
  {
    randomIndex = i;
    if(random){
      randomIndex = rand() % pages * BLOCK_SIZE;
    }
    randomPtr = (void*)(&buffer[randomIndex]);

    counter[i*4] = memaccesstime(randomPtr);
    memaccesstime((void*)((int)randomPtr+1));
    counter[i*4+1] = memaccesstime(randomPtr);

    if(flush)
     flush_l3(buffer, pages, BLOCK_SIZE);

    counter[i*4+2] = memaccesstime(randomPtr);
    counter[i*4+3] = memaccesstime(randomPtr);

    //memaccesstime_test(randomPtr);
    //memaccesstime_test(randomPtr);
    //memaccesstime_test(randomPtr);
    sum += counter[i*4];
  }

  if(print) {
    for(int i=0; i<rounds; i++)
    {
      printf("index: %p ,", randomPtr);
      printf("%" PRIu32 ", %" PRIu32 ", ", counter[i*4], counter[i*4+1]);
      
      if(flush)
      printf("flush L3, ");

      printf("%" PRIu32 ", %" PRIu32 "\n",  counter[i*4+2], counter[i*4+3]);
    }
  }

  free(buffer);
  return sum/rounds;
}

void counter_consistency_test(){
    for(int i=0; i<10000; i++){
    uint32_t a = SAB_lib_get_counter_value();
    uint32_t b = SAB_lib_get_counter_value();
    printf("%i ",b-a);
    if(i % 1000 == 999){
      putchar('\n');
    }
  }
  SAB_terminate_counter_sub_worker();
  exit(1);
}

void mem_access_testing(int rounds, int print){
  printf("random access\n");
  printf("mean:%i\n", test_mem_access(1, rounds, print));
  printf("linear access\n");
  printf("mean:%i\n", test_mem_access(0, rounds, print));
  //SAB_terminate_counter_sub_worker();
  //exit(1);
}

int main(int ac, char **av) {
  //l3-cache i7-4770: 16-way-ass, 8192sets => 4+13+6=23bits (8MiB)
  warmup(1024*1024*128); //warm up 2^27 counts operations ~ 2^30 cycles

  float resolution_ns = 101;
  //while(resolution_ns > 100){
    resolution_ns = SAB_get_resolution_ns(1000);
  //} 
  printf("resolution SAB-timer: %f ns\n", resolution_ns);

  //counter_consistency_test();

  mem_access_testing(100, 0);


  l3pp_t l3 = l3_prepare(NULL);
  
  int nsets = l3_getSets(l3);
  int nmonitored = nsets/64;
  printf("nmonitored: %i\n",nmonitored);
  printf("alloc %i Bytes\n", SAMPLES * nmonitored * sizeof(uint16_t));
  
  SAB_terminate_counter_sub_worker();
  
  
  //exit(1);

  // for (int i = 17; i < nsets; i += 64)
  //   l3_monitor(l3, i);

  
  // uint16_t *res = calloc(SAMPLES * nmonitored, sizeof(uint16_t));
  // for (int i = 0; i < SAMPLES * nmonitored; i+= 4096/sizeof(uint16_t))
  //   res[i] = 1;

  // l3_repeatedprobe(l3, SAMPLES, res, 0);

  // printf("size of eviction sets\n");
  // for(int i = 0; i < nmonitored; i++){
  //   vlist_t list = l3->groups[l3->monitoredset[i] / l3->groupsize];
  //   printf("%d ", list->len);
  // }
  // printf("\nnumber of accesses with access_time > L3_THRESHOLD in each evictionset\n");
  // printf("x-axis eviction-sets, y-axis sample\n");

  // for (int i = 0; i < SAMPLES; i++) {
  //   for (int j = 0; j < nmonitored; j++) {
  //     printf("%d ", res[i*nmonitored + j]);
  //   }
  //   if(nmonitored > 0)
  //     putchar('\n');
  // }

  // free(res);
  // l3_release(l3);
  // SAB_terminate_counter_sub_worker();
}
