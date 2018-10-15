#include <assert.h>
#include <inttypes.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

//#include <util.h>
#include "low.h"
#include "vlist.h"
#include "SABcounter.h"
#include "l3.h"
#include "es_management.h"
#include "printf_wrapper.h"
#include "storefor_find_es.h"

// set ptr to app state for context switches between wasm and javascript
// called by javascript
extern void set_app_state_ptr(uint32_t);

// #define LNEXT(t) (*(void **)(t))

// struct timer_info *info;

int main(int ac, char **av)
{
  // char* test = malloc(1024);
  // int t = *((int*)(test+1));
  // save app state for switches between javascript and wasm
  struct app_state *this_app_state =
      (struct app_state *)calloc(sizeof(struct app_state), 1);
  set_app_state_ptr((uint32_t)this_app_state);
  this_app_state->type = 0;
  this_app_state->idle_mean_values = 0;
  this_app_state->monitored_es_index_vec = 0;

  // l3-cache i7-4770: 16-way-ass, 8192sets => 4+13+6=23bits (8MiB)

  float resolution_ns = get_timer_resolution();

  // int ptr = (int)resolution_ns;
  // uint32_t val = gcc_test_opt((void *)ptr);
  // printf_ex("%i\n", val);

  // for (int i = 0; i < 1 * 1000 * 1000; i++)
  // {
  // }

  // counter_consistency_test(1, 5000000, 1000000);

  this_app_state->l3_threshold = mem_access_testing(100000, 0);
  // this_app_state->l3_threshold = 45;
  this_app_state->l3_threshold = 31;
  //sandy 36
  //haswell 31
  // flush_l3(0,0,0);
  // mem_access_testing(100000, 0);
  // exit(1);
  printf_ex("----------------TESTS FINISHED------------------\n");

  //uncomment for storefor bench
  //storefor_build_es(this_app_state, 0, 20);

  //storefor_write_SAB();

  // energy saving option, counter is started on demand
  // SAB_terminate_counter_sub_worker();

  // build_es((void*)this_app_state);

  // sample_es((void*)this_app_state);

  // print_res(l3, nmonitored);

  // free(this_app_state->res);
  // l3_release(this_app_state->l3);
  // SAB_terminate_counter_sub_worker();
}
