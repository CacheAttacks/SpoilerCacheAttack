#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <inttypes.h>
#include <strings.h>

//#include <util.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "SABcounter.h"

//tell javascript main thread ptr add from res array in wasm memory region
extern void set_ptr_to_data(uint32_t, int, int, int);

extern void print_plot_new_tab(void);

#define BLOCK_SIZE 8
#define SAMPLES 50
#define LNEXT(t) (*(void **)(t))


//TODO fix ideen:
//random zugriff auf es oder rückwärts durchlauf
//debug ausgaben von zeiten
//debug adresse von rausgeworfenen add aus es
//change add offset

struct timer_info *info;

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

    void *randomPtr_page = (void*)(((int)randomPtr >> 12) << 12);
    memaccess(randomPtr_page);

    counter[i*4] = memaccesstime(randomPtr,info);
    memaccesstime((void*)((int)randomPtr+1), info);
    counter[i*4+1] = memaccesstime(randomPtr,info);

    if(flush)
     flush_l3(buffer, pages, BLOCK_SIZE);

    memaccess(randomPtr_page);

    counter[i*4+2] = memaccesstime(randomPtr,info);
    counter[i*4+3] = memaccesstime(randomPtr,info);

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

void counter_consistency_test(int mean, uint32_t counts, uint32_t range){
  int sum = 0;
  uint64_t iterations = 0;
    for(uint32_t i=0; i<counts; i++){
    uint32_t a = SAB_lib_get_counter_value();
    uint32_t b = SAB_lib_get_counter_value();
    iterations++;
    sum += b-a;
    if(!mean)
      printf("%i ",b-a);
    if(i % 1000 == 999){
      if(!mean)
        putchar('\n');
    }
    if(i % range == range-1){
      if(mean)
        printf("mean last %i: %i, iterations %llu, last counter tick %"PRIu32"\n", range, sum/range, iterations, b);
      sum = 0;
    }
  }
  SAB_terminate_counter_sub_worker();
  exit(1);
}

int mem_access_testing(int rounds, int print){
  printf("random access %i rounds\n", rounds);
  int mean_random = test_mem_access(1, rounds, print);
  printf("mean:%i\n", mean_random);
  printf("linear access\n");
  int mean_linear = test_mem_access(0, rounds, print);
  printf("mean:%i\n", mean_linear);
  //SAB_terminate_counter_sub_worker();
  //exit(1);
  if(mean_random < mean_linear - 10){
    printf("cannot differ random/linear accesses!\n");
  }
  if(mean_random - mean_linear <= 10){
    printf("mean_random - mean_linear < 10\n");
    exit(1);
  }

  int threshold = mean_linear + (((mean_random - mean_linear)/2));
  printf("random/linear threshold: %i\n", threshold);
  return threshold;
}

int main(int ac, char **av) {
  // char str[100];
  // printf( "Enter a value :");
  // scanf("%s", str);
  // printf("str: %s", str);
  // exit(1);


  //l3-cache i7-4770: 16-way-ass, 8192sets => 4+13+6=23bits (8MiB)
  info = (struct timer_info*)malloc(sizeof(struct timer_info));
  bzero(info, sizeof(struct timer_info));
  warmup(1024*1024*128); //warm up 2^27 counts operations ~ 2^30 cycles
  printf("warm-up finished\n");

  //counter_consistency_test(1, 500000000, 1000000);

  float resolution_ns = 101;
  //while(resolution_ns > 100){
    resolution_ns = SAB_get_resolution_ns(1000);
  //} 
  printf("resolution SAB-timer: %f ns\n", resolution_ns);

  

  //int l3_threshold = mem_access_testing(100000, 0);
  int l3_threshold = 31;
  // printf("hallo\n");
  // flush_l3(0,0,0);
  // mem_access_testing(100000, 0);
  //exit(1);
  printf("----------------TESTS FINISHED------------------\n");

  l3pp_t l3;
#ifdef BENCHMARKMODE
  uint32_t *timer_array = calloc(BENCHMARKRUNS, sizeof(uint32_t));
  for(int i=0; i<BENCHMARKRUNS; i++)
  {
#endif
    uint32_t timer_before = Performance_now();
    l3 = l3_prepare(NULL, l3_threshold);
    uint32_t timer_after = Performance_now();

    printf("Eviction set total time: %u sec\n", (timer_after-timer_before)/1000);
#ifdef BENCHMARKMODE
    timer_array[i] = timer_after-timer_before;
  }
  l3_release(l3);
  SAB_terminate_counter_sub_worker();
  exit(1);
#endif  
  
  int nsets = l3_getSets(l3);
  int nmonitored = nsets/64;
  printf("nmonitored: %i\n",nmonitored);
  printf("alloc %i Bytes\n", SAMPLES * nmonitored * sizeof(uint32_t));
  
  //SAB_terminate_counter_sub_worker();
  
  for (int i = 17; i < nsets; i += 64)
    l3_monitor(l3, i);

  RES_TYPE *res = calloc(SAMPLES * nmonitored, sizeof(RES_TYPE));
  for (int i = 0; i < SAMPLES * nmonitored; i+= 4096/sizeof(RES_TYPE))
    res[i] = 1;

  //2500 counter iterations ~ 10us
  l3_repeatedprobe(l3, SAMPLES, res, 4000);

  //update ptr, type = 0 => Uint16
  set_ptr_to_data((uint32_t)res, nmonitored, SAMPLES, 0);

  printf("set_ptr_to_data: %p\n", res);

  print_plot_new_tab();

  // printf("size of eviction sets\n");
  // for(int i = 0; i < nmonitored; i++){
  //   vlist_t list = l3->groups[l3->monitoredset[i] / l3->groupsize];
  //   printf("%d ", list->len);
  // }
  // printf("\naccess_time for each evictionset per timeslot\n");
  // printf("x-axis eviction-sets, y-axis sample\n");

  // for (int i = 0; i < SAMPLES; i++) {
  //   for (int j = 0; j < nmonitored; j++) {
  //     printf("%d ", res[i*nmonitored + j]);
  //   }
  //   if(nmonitored > 0)
  //     putchar('\n');
  // }

  //free(res);
  l3_release(l3);
  SAB_terminate_counter_sub_worker();
}
