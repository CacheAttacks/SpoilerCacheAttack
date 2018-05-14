#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "es_management.h"

void set_monitored_es(void* app_state_ptr, int min_index, int max_index){
  struct app_state* this_app_state = (struct app_state*)app_state_ptr;
  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets/64;
  if(min_index == 0 && max_index == 0)
  {
    max_index = nmonitored-1;
  }
  if(min_index < 0){
    printf("min_index < 0\n");
    return;
  }
  if(max_index >= nmonitored){
    printf("max_index >= number_of_es\n");
    return;
  }
  if(max_index < min_index){
    printf("max_index < min_index\n");
    return;
  }

  l3_unmonitorall(this_app_state->l3);

  printf("monitor from %i to %i\n", min_index, max_index);

  for (int i = min_index*64; i < (max_index+1)*64; i += 64)
    l3_monitor(this_app_state->l3, i);

  this_app_state->monitored_es_changed = 1;
}

uint32_t get_time_in_ms(){
#ifdef WASM
    return Performance_now();
#else
    return 0;
#endif
}

void build_es(void* app_state_ptr, int max_es){
  struct app_state* this_app_state = (struct app_state*)app_state_ptr;

  if(!this_app_state->l3_threshold){
    printf("l3_threshold not set!\n");
    exit(1);
  }

  //if es is already present, clear allocated mem
  if(this_app_state->l3){
    l3_release(this_app_state->l3);
    this_app_state->l3 = 0;
  }
  if(this_app_state->res){
    free(this_app_state->res);
    this_app_state->res = 0;
  }

  if(!max_es){
    max_es = INT_MAX;
  }

  //reset value to trigger reallocation of res array
  this_app_state->number_of_samples_old = 0;

#ifdef WASM
  warmup(1024*1024*128); //warm up 2^27 counts operations ~ 2^30 cycles
  printf("warm-up finished\n");
#endif

#ifdef BENCHMARKMODE
  uint32_t *timer_array = calloc(BENCHMARKRUNS, sizeof(uint32_t));
  for(int i=0; i<BENCHMARKRUNS; i++)
  {
#endif
    uint32_t timer_before = get_time_in_ms();
    this_app_state->l3 = l3_prepare(NULL, this_app_state->l3_threshold, max_es);
    uint32_t timer_after = get_time_in_ms();

    printf("Eviction set total time: %u sec\n", (timer_after-timer_before)/1000);
#ifdef BENCHMARKMODE
    timer_array[i] = timer_after-timer_before;
  }
  for(int i=0; i<BENCHMARKRUNS; i++){
    printf("%u ", timer_array[i]);
  }
  printf("\n");
  l3_release(l3);
  SAB_terminate_counter_sub_worker();
  exit(1);
#endif  

  int nsets = l3_getSets(this_app_state->l3);
  int nmonitored = nsets/64;
  printf("nmonitored: %i\n",nmonitored);

  set_monitored_es(app_state_ptr, 0, 0);
}

void sample_es(void* app_state_ptr, int number_of_samples, int slot_time){
  struct app_state* this_app_state = (struct app_state*)app_state_ptr;
  //2500 counter iterations ~ 10us

  if(!this_app_state->l3){
    printf("app_state_ptr->l3 is null! Already called build_es?\n");
    return;
  }

  if(number_of_samples <= 0){
    number_of_samples = SAMPLES;
  }

  //avoid reallocation of res array if called with same parameter
  if(this_app_state->monitored_es_changed || 
  !this_app_state->number_of_samples_old || 
  this_app_state->number_of_samples_old != number_of_samples) {
    if(this_app_state->res){
      free(this_app_state->res);
    }  
    this_app_state->monitored_es_changed = 0;
    this_app_state->res = calloc(number_of_samples * this_app_state->l3->nmonitored, sizeof(RES_TYPE));
    //for (int i = 0; i < number_of_samples * this_app_state->l3->nmonitored; i+= 4096/sizeof(RES_TYPE))
    //  this_app_state->res[i] = 1;
  }

  l3_repeatedprobe(this_app_state->l3, number_of_samples, this_app_state->res, 0);
 
#ifdef WASM
  //update ptr, type = 0 => Uint16
  set_ptr_to_data((uint32_t)this_app_state->res, number_of_samples, this_app_state->l3->nmonitored, slot_time);

  printf("set_ptr_to_data: %p\n", this_app_state->res);

  print_plot_data(); 
#endif

  this_app_state->number_of_samples_old = number_of_samples;
}