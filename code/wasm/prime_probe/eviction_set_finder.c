#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <inttypes.h>
#include <strings.h>
#include <stdbool.h>
#include <limits.h>

//#include <util.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "SABcounter.h"
#include "es_management.h"

//set ptr to app state for context switches between wasm and javascript
//called by javascript
extern void set_app_state_ptr(uint32_t);

#define BLOCK_SIZE 8
#define LNEXT(t) (*(void **)(t))

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
    //exit(1);
  }

  int threshold = mean_linear + (((mean_random - mean_linear)/2));
  printf("random/linear threshold: %i\n", threshold);
  return threshold;
}

float get_timer_resolution(){
    float resolution_ns = 101;
  //while(resolution_ns > 100){
    resolution_ns = SAB_get_resolution_ns(1000);
  //} 
  printf("resolution SAB-timer: %f ns\n", resolution_ns);
  return resolution_ns;
}

void print_res(l3pp_t l3, RES_TYPE *res, int nmonitored){
  printf("size of eviction sets\n");
  for(int i = 0; i < nmonitored; i++){
    vlist_t list = l3->groups[l3->monitoredset[i] / l3->groupsize];
    printf("%d ", list->len);
  }
  printf("\naccess_time for each evictionset per timeslot\n");
  printf("x-axis eviction-sets, y-axis sample\n");

  for (int i = 0; i < SAMPLES; i++) {
    for (int j = 0; j < nmonitored; j++) {
      printf("%d ", res[i*nmonitored + j]);
    }
    if(nmonitored > 0)
      putchar('\n');
  }
}

int main(int ac, char **av) {
  //save app state for switches between javascript and wasm
  struct app_state* this_app_state = (struct app_state*)calloc(sizeof(struct app_state),1);
  set_app_state_ptr((uint32_t)this_app_state);
  this_app_state->type = 0;

  //l3-cache i7-4770: 16-way-ass, 8192sets => 4+13+6=23bits (8MiB)

  float resolution_ns = get_timer_resolution();  

  //counter_consistency_test(1, 5000000, 1000000);

  this_app_state->l3_threshold = mem_access_testing(100000, 0);
  //this_app_state->l3_threshold = 45;
  this_app_state->l3_threshold = 31;
  // flush_l3(0,0,0);
  // mem_access_testing(100000, 0);
  //exit(1);
  printf("----------------TESTS FINISHED------------------\n");

  //energy saving option, counter is started on demand
  //SAB_terminate_counter_sub_worker();

  //build_es((void*)this_app_state);

  //sample_es((void*)this_app_state);

  //print_res(l3, nmonitored);

  //free(this_app_state->res);
  //l3_release(this_app_state->l3);
  //SAB_terminate_counter_sub_worker();
}
