#include "config.h"
#include <assert.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "low.h"
#include "vlist.h"
#include "probe.h"
#include "timestats.h"
#include "es_management.h"
#include "printf_wrapper.h"
#include "l3.h"
#include "l3_test.h"
#include "storefor_find_es.h"

/**
 * @brief Find an eviction-set for a random pick from a list of candidates
 * 
 * @param es candidate-set as list (maybe empty at start)
 * @param candidates list of candidates aka memory-blocks
 * @return void* 
 */
void *expand(vlist_t es, vlist_t candidates) {
  while (vl_len(candidates) > 0) {
    void *current = vl_poprand(candidates);
    if (vl_len(es) > 16 &&
        vl_len(es) > vl_len(candidates) * EXPAND_START_VALUE_FACTOR &&
        checkevict_safe(es, current, vl_len(es), 0, EXPAND_ITERATIONS)) {
      // printf_ex("found es! size:%i\n", vl_len(es));
      // expand_test(es, current);
      // checkevict(es, current, vl_len(es), 1);
      // checkevict(es, current, vl_len(es), 1);
      // checkevict(es, current, vl_len(es), 1);
      // exit(1);

      return current;
    }
    vl_push(es, current);
  }
  return NULL;
}

/**
 * @brief Reduce the size of a given eviction-set for a candidate to the L3-cache associativity. Add deleted entries from the eviction-set back to the list of candidates.
 * 
 * @param es eviction-set as list
 * @param candidates list of candidates aka memory-blocks
 * @param current candidate (evicted by eviction-set)
 */
void contract(vlist_t es, vlist_t candidates, void *current) {
  for (int i = 0; i < vl_len(es);) {
    void *cand = vl_get(es, i);
    vl_del(es, i);
    // why cflush??? we want to check if smaller set still evicts current
    // we access current beforehand, access smaller set, check if current was
    // evicted load each element in evection set instead of clflush
    // access_es(es);
    // clflush(current);
    if (checkevict_safe(es, current, vl_len(es), 0, CONTRACT_ITERATIONS))
      vl_push(candidates, cand);
    else {
      vl_insert(es, i, cand);
      i++;
    }
  }
}

/**
 * @brief Extension of contract. Deletes multiple entries at once.
 * 
 * @param es eviction-set as list
 * @param candidates list of candidates aka memory-blocks
 * @param current candidate (evicted by eviction-set)
 * @param del_number Number of deleted entries per iteration
 * @return int 
 */
int contract_multiple(vlist_t es, vlist_t candidates, void *current,
                             int del_number) {
  int contract_at_least_once = 0;
  vlist_t tmp_list = vl_new();
  for (int i = 0; i < vl_len(es);) {
    for (int j = 0; j < del_number && i < vl_len(es); j++) {
      vl_push(tmp_list, vl_del(es, i));
    }
    if (checkevict_safe(es, current, vl_len(es), 0, CONTRACT_ITERATIONS)) {
      while (vl_len(tmp_list) > 0) {
        vl_push(candidates, vl_pop(tmp_list));
      }
    } else {
      while (vl_len(tmp_list) > 0) {
        vl_insert(es, i, vl_pop(tmp_list));
      }
      i += del_number;
      contract_at_least_once = 1;
    }
  }
  return contract_at_least_once;
}

/**
 * @brief Extension of contract. Deletes multiple entries at once.
 * 
 * @param es eviction-set as list
 * @param candidates list of candidates aka memory-blocks
 * @param current candidate (evicted by eviction-set)
 * @param associativity L3-cache associativity
 */
void contract_advanced(vlist_t es, vlist_t candidates, void *current,
                              int associativity) {
  //"perfect" es has 16 elements => therefore split es in vl_len(es)/(17) parts
  // at least one part can be deleted completly!
  int boundary = (int)(vl_len(es) / (associativity + 1));
  // int first_del_number = (int)(vl_len(es) * CONTRACT_FIRST_DEL_FACTOR);
  int first_del_number = 12;
  // int second_del_number = (int)(vl_len(es) * CONTRACT_SECOND_DEL_FACTOR);
  // int second_del_number = 6;

  if (first_del_number > 1) {
    if (!contract_multiple(es, candidates, current, first_del_number)) {
      return;
    }
    // if(second_del_number > 1) {
    //   contract_multiple(es, candidates, current, second_del_number);
    // }
  }

  for (int i = 0; i < vl_len(es);) {
    void *cand = vl_get(es, i);
    vl_del(es, i);

    if (checkevict_safe(es, current, vl_len(es), 0, CONTRACT_ITERATIONS))
      vl_push(candidates, cand);
    else {
      vl_insert(es, i, cand);
      i++;
    }
  }
}


/**
 * @brief Collect phase of eviction-set search.
 * 
 * @param es eviction-set as list
 * @param candidates list of candidates aka memory-blocks
 * @return int 
 */
int collect(vlist_t es, vlist_t candidates /*, vlist_t set*/) {
  int deleted = 0;
  for (int i = vl_len(candidates); i--;) {
    // do not use collected memory blocks further
    void *p = vl_del(candidates, i);
    if (checkevict_safe(es, p, vl_len(es), 0, COLLECT_ITERATIONS)) {
      // vl_push(set, p);
      //printf_ex("%i ", ((int)p)-2048);
      deleted++;
    } else {
      vl_push(candidates, p);
    }
  }
  return deleted;
}

/**
 * @brief Tests if candiate-set is an eviction-set for the given candidate
 * 
 * @param es candidate-set as list (possible Eviction-Set for candidate)
 * @param current candidate (maybe evicted by candidate-set)
 */
void expand_test(vlist_t es, void *current) {
  for (int a = 0; a < 10; a++) {
    access_es(es);
    for (int i = 0; i < 2; i++) {
      printf_ex("diff%i: %" PRIu32 " ", i,
             memaccesstime_abs_double_access(current));
    }
    putchar('\n');
  }
}

/**
 * @brief 
 * 
 * @param es candidate-set as list (possible Eviction-Set for candidate)
 * @param candidates list of candidates aka memory-blocks
 * @return void* 
 */
void *expand_storefor(vlist_t es, vlist_t candidates) {
  for(int i=0; vl_len(candidates)>0;i++) {
    vl_push(es, vl_pop(candidates));
  }
  printf_ex("%i\n",vl_len(es));

  for(int i=0; i<vl_len(es);i++) {
    void* current = vl_del(es,i);
    if(checkevict_safe(es, current, vl_len(es), 0, EXPAND_ITERATIONS)){
      printf_ex("found\n");
      return current;
    }
    vl_insert(es, i, current);
  }
  return NULL;
}