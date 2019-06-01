/*
 * Copyright 2016 CSIRO
 *
 * This file is part of Mastik.
 *
 * Mastik is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Mastik is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Mastik.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
* Modified 2018 for ITS
*/
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
#ifdef __APPLE__
#include <mach/vm_statistics.h>
#endif

#include "low.h"
#include "vlist.h"
#include "probe.h"
#include "timestats.h"
#include "es_management.h"
#include "printf_wrapper.h"
#include "l3.h"
#include "l3_phases.h"
#include "l3_test.h"
#include "storefor_find_es.h"

int L3_THRESHOLD_GLOBAL = 10000;
int L3_THRESHOLD_GLOBAL_OFFSET = 0;

//saves debug info about timer values
struct timer_info *info = 0;
void set_timer_info(){
  if(info == 0){
    info = (struct timer_info *)malloc(sizeof(struct timer_info));
    bzero(info, sizeof(struct timer_info));
  }
}

/**
 * @brief Get infos about the L3-Cache. Fixed values, because there is no CPUID-instruction in the brwoser.
 * 
 * @param l3 Ptr to l3pp struct
 */
static void fillL3Info(void *app_state_ptr) {
  // l3-cache i7-4770: 16-way-ass, 8192sets, 4slices =>
  // 4(ass)+13(sets)+6(line)=23bits (8MiB) l3-cache i3-5010U: 12-way-ass,
  // 4096sets, 3MiB like 16-way-ass and 4MiB => 4(ass)+12(sets)+6(line)=22bits
  // (4MiB) works also for other CPUs

  struct app_state *this_app_state = (struct app_state *)app_state_ptr;
  l3pp_t l3 = this_app_state->l3;

  l3->l3info.associativity = this_app_state->l3_cache_associativity;
  l3->cpuidInfo.cacheInfo.sets = this_app_state->l3_cache_sets;
  l3->l3info.slices = this_app_state->l3_cache_slices;
  l3->l3info.setsperslice = l3->cpuidInfo.cacheInfo.sets / l3->l3info.slices;
  l3->l3info.bufsize = l3->l3info.associativity * l3->l3info.slices *
                       l3->l3info.setsperslice * this_app_state->l3_cache_line_size *
                       this_app_state->l3_cache_size_multi;
  l3->l3info.l3_cache_size_multi = this_app_state->l3_cache_size_multi;

  printf_ex("l3->l3info.bufsize: %i MiB\n", l3->l3info.bufsize/1024/1024);
  print_parameters(app_state_ptr);
}

void print_parameters(void *app_state_ptr)
{
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  printf_ex("l3_cache_threshold: %i, l3_cache_associativity: %i, l3_cache_sets: %i, l3_cache_slices: %i, l3_cache_line_size: %i, l3_cache_line_bits: %i, l3_cache_size_multi: %i\n", 
  this_app_state->l3_threshold, this_app_state->l3_cache_associativity, this_app_state->l3_cache_sets, this_app_state->l3_cache_slices, this_app_state->l3_cache_line_size, this_app_state->l3_cache_line_bits, this_app_state->l3_cache_size_multi);
}

/**
 * @brief extend version: change between no bprobe and direct access to all 16 add or bprobe and access to 8 add with distance 2
 * 
 * @param l3 Ptr to l3pp struct
 * @param set Used to determine the eviction set
 * @param bprobe bprobe=1 => Add pointers for bprobe
 * @return void* 
 */
void *sethead_ex(l3pp_t l3, int set,
                 int bprobe) { // vlist_t list, int count, int offset) {
  // load eviction set
  vlist_t list = l3->groups[set / l3->groupsize];

  int count = l3->l3info.associativity;
  if (count == 0 || vl_len(list) < count)
    count = vl_len(list);

  int offset = (set % l3->groupsize) * L3_CACHE_LINE_SIZE;

  // pseudocode for following code:
  // enables to cycle through memory_blocks with preferred offset
  // foreach(i in 1:size(eviction_set)){ //each memory_block is page of size
  // 4096
  // *(memory_block[i].add + offset) = memory_block[(i+1) %
  // size(eviction_set)].add + offset;
  // *(memory_block[i].add + offset + 1) =
  //                      memory_block[(i - 1 + size(eviction_set)) %
  //                      size(eviction_set)].add + offset + 1;
  //}

  for (int i = 0; i < count; i++) {
    int distance_between_add = 1;
    if (bprobe) {
      // cause bprobe only 8 add entry-points can be saved into the cacheline
      distance_between_add = 2;

      // for bprobe
      for (int add_off = 0; add_off < 16; add_off += distance_between_add) {
        int list_index = (i + add_off) % count;
        int cacheline_offset = offset + (add_off + 1) * sizeof(void *);
        LNEXT(OFFSET(vl_get(list, list_index), cacheline_offset)) = OFFSET(
            vl_get(list, (list_index + count - 1) % count), cacheline_offset);

        //printf_ex("bp(add_off=%i): %i[%i] -> %i[%i]\n", add_off, list_index, (add_off + 1),  (list_index + count - 1) % count, (add_off + 1));
      }
      // LNEXT(OFFSET(vl_get(list, i), offset+sizeof(void*))) =
      // OFFSET(vl_get(list, (i + count - 1) % count), offset+sizeof(void *));
    }

    // for other probe algos, e.g. probetime_split_4
    for (int add_off = 0; add_off < 16; add_off += distance_between_add) {
      int list_index = (i + add_off) % count;
      int cacheline_offset = offset + add_off * sizeof(void *);
      LNEXT(OFFSET(vl_get(list, list_index), cacheline_offset)) =
          OFFSET(vl_get(list, (list_index + 1) % count), cacheline_offset);

      //printf_ex("(add_off=%i): %i[%i] -> %i[%i]\n", add_off, list_index, add_off,  (list_index + 1) % count, add_off);
    }
  }

  return OFFSET(vl_get(list, 0), offset);
}

/**
 * @brief Creates a "long" Ptr-chain for prime spam with multiple eviction sets (with bprobe option)
 * 
 * @param l3 Ptr to l3pp struct
 * @param ptr_arr Array to all ptr
 * @param ptr_arr_size Size of ptr_arr
 * @return void* 
 */
void *sethead_prime_spam(l3pp_t l3, void** ptr_arr, int ptr_arr_size){
  for(int j = 0; j < ptr_arr_size; j++){
    //make sure ptr_arr points to begin of the cache-line
    int p = (((int)ptr_arr[j] >> 6) << 6);

    for (int add_off = 0; add_off < 16; add_off += 2) {
      int cacheline_offset = (add_off + 1) * sizeof(void *);
      int new_p = (((int)ptr_arr[(j + ptr_arr_size - (add_off + 1)) % ptr_arr_size] >> 6) << 6);
      LNEXT(OFFSET(p, cacheline_offset)) = OFFSET(new_p, cacheline_offset);

      //printf_ex("bp(add_off=%i): %i[%i] -> %i[%i]\n", add_off, j, (add_off + 1),  (j + ptr_arr_size - (add_off + 1)) % ptr_arr_size, (add_off + 1));
    }

    for (int add_off = 0; add_off < 16; add_off += 2) {
      int cacheline_offset = (add_off) * sizeof(void *);
      int new_p = (((int)ptr_arr[(j + (add_off + 1)) % ptr_arr_size] >> 6) << 6);
      LNEXT(OFFSET(p, cacheline_offset)) = OFFSET(new_p, cacheline_offset);

      //printf_ex("(add_off=%i): %i[%i] -> %i[%i]\n", add_off, j, add_off,  (j + (add_off + 1)) % ptr_arr_size, add_off);
    }
  }

  return (void*)(((int)ptr_arr[0] >> 6) << 6);
}

/**
 * @brief Wrapper for sethead_ex
 * 
 * @param l3 Ptr to l3pp struct
 * @param set Used to determine the eviction set
 * @return void* 
 */
void *sethead(l3pp_t l3, int set) { return sethead_ex(l3, set, 1); }

void prime(void *pp, int reps) { walk((void *)pp, reps); }

#define str(x) #x
#define xstr(x) str(x)

/**
 * @brief Tests if a Candiate-Set is an Eviction-Set for a given candidate
 * 
 * @param list candidate-set as ptr-chain (possible Eviction-Set for candidate)
 * @param void candidate (maybe evicted by candidate-set)
 * @param walk_size Max steps through candidate-set (default is size(candidate-set))
 * @param print print=1 => Print additional debug output
 * @return int 
 */
static int timedwalk(void *list, register void *candidate, int walk_size,
                     int print) {
#ifdef DEBUG
  static int debug = 100;
  static int debugl = 1000;
#else
#define debug 0
#endif // DEBUG
  if (list == NULL)
    return 0;
  if (LNEXT(list) == NULL)
    return 0;
  void *start = list;
  ts_t ts = ts_alloc();
  // void *c2 = (void *)((uintptr_t)candidate ^ 0x200);
  // LNEXT(c2) = candidate;
  // clflush(c2);
  // if(print)
  //  printf_ex("time:");
  int *buffer;
  int pages, block_size;
  int or_flush, or_walk;
  // if(print){
  //   pages = 1024*1024*2;
  //   block_size = 64;
  //   buffer = mmap(NULL, block_size*pages, PROT_READ|PROT_WRITE,
  //   MAP_ANON|MAP_PRIVATE, -1, 0);
  // }
  volatile int a = memaccess(candidate);
  for (int i = 0;
       i < CHECKTIMES *
               (debug ? FACTORDEBUG : (print ? FACTORPRINT : FACTORNORMAL));
       i++) {

    // if(print)
    //   or_flush = flush_l3(buffer,pages,block_size);
#ifdef WASM
walk_through(list);
    //or_walk = walk(list, walk_size);
#else
    or_walk = walk(list, 20); //was default why???
#endif
    // void *p = LNEXT(c2);

    // try to reduce TLB noise (drive-by cache paper)
    // access memory in the same page
    // use page start (last 12 bits zero)
    // maybe collide with ADDRESS_OFFSET
    //void *candiate_page = (void *)(((uintptr_t)candidate >> 12) << 12);
    //memaccess(candiate_page);

    uint32_t time = memaccesstime(candidate, info);

    ts_add(ts, time);
    // if(print)
    //  printf_ex("%i ", time);
  }
  int rv = ts_median(ts);
  // printf_ex("mean:%i\n",rv);
  if (print) {
    printf_ex("mean:%i ", rv);
    free(buffer);
  }
#ifdef DEBUG
  if (!--debugl) {
    debugl = 1000;
    debug++;
  }
  if (debug) {
    printf_ex("--------------------\n");
    for (int i = 0; i < TIME_MAX; i++)
      if (ts_get(ts, i) != 0)
        printf_ex("++ %4d: %4d\n", i, ts_get(ts, i));
    debug--;
  }
#endif // DEBUG
  ts_free(ts);
  return rv;
}

/**
 * @brief Tests if a Candiate-Set is an Eviction-Set for a given candidate. Additionally builds ptr-chain for timedwalk.
 * 
 * @param es candidate-set as list (possible Eviction-Set for candidate)
 * @param candidate candidate (maybe evicted by candidate-set)
 * @param walk_size Max steps through candidate-set (default is size(candidate-set))
 * @param print print=1 => Print additional debug output
 * @return int 
 */
int checkevict(vlist_t es, void *candidate, int walk_size, int print) {
  if (vl_len(es) == 0)
    return 0;
  if (walk_size == 0)
    printf_ex("walk_size == 0\n");
  for (int i = 0; i < vl_len(es); i++)
    LNEXT(vl_get(es, i)) = vl_get(es, (i + 1) % vl_len(es));
  int timecur = timedwalk(vl_get(es, 0), candidate, walk_size, print);
  // printf_ex("$%i ", timecur);
  // if(timecur > (L3_THRESHOLD_GLOBAL + L3_THRESHOLD_GLOBAL_OFFSET))
  // printf_ex("timecur %i\n",timecur);
  return timecur;
}

/**
 * @brief repeat eviction-set testing multiple times to reduce possible errors. breaks if the results lead to a contradiction
 * 
 * @param es candidate-set as list (possible Eviction-Set for candidate)
 * @param candidate candidate (maybe evicted by candidate-set)
 * @param walk_size Max steps through candidate-set (default is size(candidate-set))
 * @param print print=1 => Print additional debug output
 * @param proofs Number of tests
 * @return int 
 */
int checkevict_safe(vlist_t es, void *candidate, int walk_size,
                           int print, int proofs) {
  if (proofs <= 0) {
    printf_ex("proofs <= 0. set proofs = 1\n");
    proofs = 1;
  }
  int counter = 0;
  for (int i = 0; i < proofs; i++) {
    if (checkevict(es, candidate, walk_size, print) <=
        (L3_THRESHOLD_GLOBAL + L3_THRESHOLD_GLOBAL_OFFSET)) {
      break;
    }
    counter++;
    if (i >= 1) {
      // checkevict(es, candidate, walk_size, 1);
    }
  }
  return counter == proofs;
}

#define DEBUG

/**
 * @brief Get l3 struct and list of addresses with page size gaps. Tries to find evicitions sets.
 * 
 * @param l3 Ptr to l3pp struct
 * @param lines buffer aka memory-blocks
 * @param storefor_mode storefor_mode=1 => Optimazations for new eviction-set search
 * @return vlist_t 
 */
vlist_t map(l3pp_t l3, vlist_t lines, int storefor_mode) {
#ifdef DEBUG
  printf_ex("lines aka memory-blocks %d\n", vl_len(lines));
  printf_ex("---------------------INFO END--------------------------\n");
#endif // DEBUG
  uint64_t time_expand = 0, time_contract = 0, time_collect = 0,
           time_datahandling = 0;
  uint32_t before = 0;
  vlist_t groups = vl_new();
  
#ifdef REUSE_CONTRACT_ENTRIES
  vlist_t es_next_it = vl_new();
#endif
  vlist_t es = vl_new();
  
  int nlines = vl_len(lines);
  int fail = 0, too_big = 0, too_small = 0, consecutive_expand_fails = 0;
  int iterations = 0, iterations_contract_failed = 0;

  int last_es_sizes_arr_index = 0;
  int *last_es_sizes_arr = (int*)calloc(TOO_BIG_TRIGGER_VALUE + TOO_SMALL_TRIGGER_VALUE + 2, sizeof(int));

  while (vl_len(lines)) {

    if (too_big > TOO_BIG_TRIGGER_VALUE ||
        too_small > TOO_SMALL_TRIGGER_VALUE) {
      if (too_big > TOO_BIG_TRIGGER_VALUE) {
        // L3_THRESHOLD_GLOBAL_OFFSET--;
      } else {
        // L3_THRESHOLD_GLOBAL_OFFSET++;
      }
#ifdef DEBUG_CHANGE_THRESHOLD
      // printf_ex("toobig %i, toosmall %i\n", too_big, too_small);
      // printf_ex("L3_THRESHOLD_GLOBAL + L3_THRESHOLD_GLOBAL_OFFSET now: %i\n", L3_THRESHOLD_GLOBAL +
      // L3_THRESHOLD_GLOBAL_OFFSET);
#endif
      too_big = 0;
      too_small = 0;
      last_es_sizes_arr_index = 0;
    }

    assert(vl_len(es) == 0);
#ifdef DEBUG
    int d_l1 = vl_len(lines);
#ifdef REUSE_CONTRACT_ENTRIES
        d_l1+= vl_len(es_next_it);
#endif
#endif // DEBUG
    if (fail > FAIL_MAX) {
      //if(!storefor_mode) {
        //printf_ex("too many failed atemps, es search canceled!\n");
      //}
      break;
    }
    iterations++;

#ifdef REUSE_CONTRACT_ENTRIES
  vl_free(es);
  es = es_next_it;
  es_next_it = vl_new();
#endif

//-------------------------------------------------------------------------------------
//-----------------------------------EXPAND-PHASE--------------------------------------
//-------------------------------------------------------------------------------------

    before = rdtscp();
    void *c;
    //if(storefor_mode)
    //  c = expand_storefor(es, lines);
    //else
      c = expand(l3, es, lines);
    time_expand += (uint64_t)get_diff(before, rdtscp());
    //printf_ex("%i\n", vl_len(es));

#ifdef DEBUG
    int d_l2 = vl_len(es);
#endif // DEBUG

    // rewind if no witness block was found by the expand operation
    if (c == NULL) {
      before = rdtscp();
      // restore delete lines (in expand operation)
      while (vl_len(es))
        vl_push(lines, vl_del(es, 0));
#ifdef DEBUG
      printf_ex("set %3d: lines: %4d expanded: %4d c=NULL\n", vl_len(groups), d_l1,
             d_l2);

      int number_of_expected_super_es = l3->cpuidInfo.cacheInfo.sets / (PAGE_SIZE / L3_CACHE_LINE_SIZE);

      if(consecutive_expand_fails > 3 && 
      vl_len(groups) < number_of_expected_super_es && //do not print this warning on the end of the es search
      !storefor_mode)
      {
        printf_ex("Try to decrease the L3-cache hit threshold.\n");
      }
#endif // DEBUG
      fail += 50;
      //L3_THRESHOLD_GLOBAL = readjustTimerThreshold();
      // if(storefor_mode){
      //   fail = FAIL_MAX+1;
      // }

      consecutive_expand_fails++;
      time_datahandling += (uint64_t)get_diff(before, rdtscp());
      continue;
    } else {
      consecutive_expand_fails = 0;
    }

//-------------------------------------------------------------------------------------
//----------------------------------CONTRACT-PHASE-------------------------------------
//-------------------------------------------------------------------------------------

#ifdef WASM
#ifdef DEBUG_CONTRACT
    printf_ex("CONTRACT (es size step):");
#endif
    int size_old = INT32_MAX;
    for (int i = 0;
         i < MAX_CONTRACT_CALLS && vl_len(es) > l3->l3info.associativity; i++) {
#ifdef BENCHMARKCONTRACT
      vl_push(l3->size_es, (void *)vl_len(es));
#endif
      before = rdtscp();
      //contract_advanced(es, lines, c, l3->l3info.associativity);
#ifdef REUSE_CONTRACT_ENTRIES
      contract(es, es_next_it, c);
#else
      contract(es, lines, c);
#endif
      uint64_t time_last_contract = (uint64_t)get_diff(before, rdtscp());
#ifdef BENCHMARKCONTRACT
      vl_push(l3->contract_time, (void *)((uint32_t)time_last_contract));
#endif
      time_contract += time_last_contract;
#ifdef DEBUG_CONTRACT
      printf_ex("%i ", vl_len(es));
#endif
      if (i == 0 && vl_len(es) >= MAX_SIZE_AFTER_FIRST_CONTRACT) {
#ifdef DEBUG_CONTRACT
        printf_ex("after first contract call => vl_len(es) >= %i => break\n",
               MAX_SIZE_AFTER_FIRST_CONTRACT);
#endif
        //break;
      }
      if (i == 1 && vl_len(es) >= MAX_SIZE_AFTER_SECOND_CONTRACT) {
#ifdef DEBUG_CONTRACT
        printf_ex("after first contract call => vl_len(es) >= %i => break\n",
               MAX_SIZE_AFTER_SECOND_CONTRACT);
#endif
        //break;
      }
      size_old = vl_len(es);
    } //end for loop
#else
    before = rdtscp();
    contract(es, lines, c);
    contract(es, lines, c);
    contract(es, lines, c);
    time_contract += (uint64_t)get_diff(before, rdtscp());
#endif

//-------------------------------------------------------------------------------------
//-----------------------TEST RESULTS OF CONTRACT-PHASE--------------------------------
//-------------------------------------------------------------------------------------
    //check whether the es size matches the constrains
    int es_size_is_valid = vl_len(es) <= l3->l3info.associativity + MAX_L3_ASSOCIATIVITY_DIFF &&
        vl_len(es) >= l3->l3info.associativity;

    before = rdtscp();
    // if(vl_len(es) < l3->l3info.associativity){
    //   printf_ex("warning vl_len(es)=%i < ass=%i!\n", vl_len(es),
    //   l3->l3info.associativity);
    // }
    int test_failed = 0;
    if (es_size_is_valid) {
#ifdef AFTERCONTRACTTEST
#if DEBUG_TEST_PRINT == 1
      printf_ex("after contract es size:%i\n", vl_len(es));
      printf_ex("evict ");
#endif
      //test the es with candidate 10 more times to validate the correctness
      for (int i = 0; i < 10; i++) {
        if (checkevict(es, c, vl_len(es), DEBUG_TEST_PRINT) <= L3_THRESHOLD_GLOBAL)
        {
          printf_ex("Validation test failed! Multiple occurrences of this warning could indicate a problem with the l3-cache hit threshold.\n");
          test_failed = 1;
        }
#if DEBUG_TEST_PRINT == 1
        printf_ex("%i ", checkevict(es, c, vl_len(es), 0));
#endif
      }
#endif // AFTERCONTRACTTEST
#ifdef ONEOUTTEST
      int oneouttest_failed = 0;
#if DEBUG_TEST_PRINT == 1
      printf_ex("\n 1 out test \n");
#endif
      //deletes one element from the es and tests the reduced set against the candidate
      //the result should always be negative (es without one entry should never be an es for the candiate)
      for (int i = 0; i < vl_len(es); i++) {
        void *element = vl_del(es, i);
        if (checkevict(es, c, vl_len(es), DEBUG_TEST_PRINT) > L3_THRESHOLD_GLOBAL)
          oneouttest_failed++;
        vl_insert(es, i, element);
      }
      if (oneouttest_failed > 1)
      {
        printf_ex("One out test failed! Multiple occurrences of this warning could indicate a problem with the l3-cache hit threshold.\n");
        test_failed = 1;
      }
#if DEBUG_TEST_PRINT == 1
      putchar('\n');
#endif
#endif // ONEOUTTEST
    }

#ifdef DEBUG
    int d_l3 = vl_len(es);
#endif // DEBUG

    // rewind if size(es) do not match associativity
    if (!es_size_is_valid || test_failed) {
      if (vl_len(es) > l3->l3info.associativity + MAX_L3_ASSOCIATIVITY_DIFF) {
        too_big++;
      } else {
        too_small++;
      }

      last_es_sizes_arr[last_es_sizes_arr_index++] = vl_len(es);

      if(too_big > TOO_BIG_TRIGGER_VALUE || too_small > TOO_SMALL_TRIGGER_VALUE)
      {
        printf_ex("The es size after the contract phase does not matches the given associativity (%i).\n", l3->l3info.associativity);
        printf_ex("The last es size after the contract phase are: ");
        for(int i=0; i<last_es_sizes_arr_index; i++)
        {
          printf_ex("%i, ", last_es_sizes_arr[i]);
        }
        printf_ex("\n");
        if(too_small > TOO_SMALL_TRIGGER_VALUE)
        {
          printf_ex("The es size after the contract phase (%i) seems to low. Try to increase the L3-cache hit threshold (also check the associativity).\n", vl_len(es));
        }
      } 
      
#ifdef REUSE_CONTRACT_ENTRIES
      //if(too_big > 0){
            //reset after 3 failed contracts in a row
            //printf_ex("reset es_next_it\n");
            while (vl_len(es_next_it))
              vl_push(lines, vl_del(es_next_it, 0));
            while (vl_len(es))
              vl_push(lines, vl_del(es, 0));
      // } else {
      //       while (vl_len(es))
      //         vl_push(es_next_it, vl_del(es, 0));
      // }
#else
      while (vl_len(es))
        vl_push(lines, vl_del(es, 0));
#endif

      vl_push(lines, c);
#ifdef DEBUG
      // printf_ex("set %3d: lines: %4d expanded: %4d contracted: %2d ",
      //        vl_len(groups), d_l1, d_l2, d_l3);
      // if (test_failed)
      //   printf_ex("test failed\n");
      // else
      //   printf_ex("contract failed\n");
      if(!test_failed){
        iterations_contract_failed++;
      }
#endif // DEBUG
      fail++;
      if(fail % 3 == 0){
        doStuff();
        //L3_THRESHOLD_GLOBAL = readjustTimerThreshold();
      }
      continue;
    }
    time_datahandling += (uint64_t)get_diff(before, rdtscp());

//-------------------------------------------------------------------------------------
//----------------------------------COLLECT-PHASE--------------------------------------
//-------------------------------------------------------------------------------------

    too_small = 0;
    too_big = 0;
    last_es_sizes_arr_index = 0;
    fail = 0;
    vlist_t set = vl_new();
    // do not add collected memory blocks to es
    // vl_push(set, c);
    before = rdtscp();
    int deleted = collect(es, lines /*, set*/);
    time_collect += (uint64_t)get_diff(before, rdtscp());

    before = rdtscp();
    while (vl_len(es)){
      //printf_ex("%#08x\n", vl_get(es, 0));
      //printf_ex("%i ", ((int)vl_get(es, 0))-2048);
      vl_push(set, vl_del(es, 0));
    }
    //printf_ex("\n");
      
#ifdef DEBUG
    printf_ex("set %3d: lines: %4d expanded: %4d contracted: %2d collected: %d\n",
           vl_len(groups), d_l1, d_l2, d_l3, deleted);
#endif // DEBUG
    vl_push(groups, set);
    if (l3->l3info.progressNotification)
      (*l3->l3info.progressNotification)(nlines - vl_len(lines), nlines,
                                         l3->l3info.progressNotificationData);
    time_datahandling += (uint64_t)get_diff(before, rdtscp());

    if (vl_len(groups) >= l3->max_es) {
      printf_ex(
          "forced break in map function, cause vl_len(group) >= max_es(%i)\n",
          l3->max_es);
      break;
    }
  } //end big while-loop

  free(last_es_sizes_arr);

  vl_free(es);
  uint64_t time_sum =
      time_expand + time_contract + time_collect + time_datahandling;
  printf_ex(
      "runtime expand: %f, contract: %f, collect %f, datahandling %f(%" PRId64
      ")\n",
      (double)time_expand / time_sum, (double)time_contract / time_sum,
      (double)time_collect / time_sum, (double)time_datahandling / time_sum,
      time_datahandling);
  printf_ex("iterations: %i\n", iterations);
  printf_ex("iterations contract failed: %i\n", iterations_contract_failed);
#ifdef REUSE_CONTRACT_ENTRIES
  printf("reuse contract entries for next expand\n");
#endif
  return groups;
}

// background number of sets = 2^13, known bits for 12bit page = 6
// physical = virtual bits for 12 page bits
// optimal case: map function find 2^7 es
// expand_group function expand these 2^7 es to 2^13 es
// function uses knwon 6 bit from page
// use property: a,b in same cache set => a + x,b + x in the same cache set
vlist_t expand_groups(vlist_t groups) {
  vlist_t all_groups = vl_new();
  for (int group_index = 0; group_index < vl_len(groups); group_index++) {
    vlist_t cur_group = (vlist_t)vl_get(groups, group_index);
    for (int offset = 0; offset < PAGE_SIZE / L3_CACHE_LINE_SIZE; offset++) {
      int inner_page_add = offset << L3_CACHE_LINE_BITS;
      vlist_t inner_page_group = vl_new();
      for (int add_index = 0; add_index < vl_len(cur_group); add_index++) {
        void *add = vl_get(cur_group, add_index);
        // printf_ex("old add %p\n", add);
        // set last 12 bits to zero
        add = (void *)((((uintptr_t)add) >> 12) << 12);
        // printf_ex("clear 12 bits add %p\n", add);
        // set bits 11 to 6 to inner_page_add
        add = (void *)((uintptr_t)add | inner_page_add);
        // printf_ex("new add %p\n", add);
        vl_push(inner_page_group, add);
      }
      // void* candidate = vl_poprand(inner_page_group);
      // printf_ex("size %i, offset %i:", vl_len(inner_page_group), offset);
      // for(int i=0; i<10; i++)
      //   checkevict(inner_page_group, candidate, vl_len(inner_page_group), 1);
      // putchar('\n');
      // vl_push(inner_page_group, candidate);

      vl_push(all_groups, inner_page_group);
    }
    vl_free(cur_group);
  }
  return all_groups;
}

/**
 * @brief Take buffer from l3 struct and try to create eviction sets
 * 
 * @param l3 Ptr to l3pp struct
 * @return int 
 */
int probemap(l3pp_t l3) {
  if ((l3->l3info.flags & L3FLAG_NOPROBE) != 0)
    return 0;
  printf_ex("l3info.bufsize:%i\n", l3->l3info.bufsize);
  printf_ex("l3->groupsize: %i\n", l3->groupsize);
  printf_ex("L3_CACHE_LINE_SIZE: %i\n", L3_CACHE_LINE_SIZE);
  vlist_t pages = vl_new();
  for (int i = 0; i < l3->l3info.bufsize; i += l3->groupsize * L3_CACHE_LINE_SIZE)
    vl_push(pages, l3->buffer + i + ADDRESS_OFFSET);
  vlist_t groups = map(l3, pages, 0);
  vlist_t all_groups = expand_groups(groups);
  vl_free(groups);

  // Store map results
  l3->ngroups = vl_len(all_groups);
  l3->groups = (vlist_t *)calloc(l3->ngroups, sizeof(vlist_t));
  for (int i = 0; i < vl_len(all_groups); i++)
    l3->groups[i] = vl_get(all_groups, i);

  vl_free(all_groups);
  vl_free(pages);
  return 1;
}

/**
 * @brief Allocate memory for eviction-set search. Init data structures for eviction-sets and starts search afterwards.
 * 
 * @param l3info Info about L3-Cache
 * @param l3_threshold timer threshold (difference between cache hit or miss)
 * @param max_es Limits the number of "super" eviction-sets (each "super" eviction-set contains 64 evcition-sets)
 * @param search_methods Select between DEFAULT and STOREFORWARDLEAKAGE
 * @return l3pp_t 
 */
l3pp_t l3_prepare(void *app_state_ptr, l3info_t l3info, int l3_threshold, int max_es, enum search_methods search_method) {
  if (ADDRESS_OFFSET == 0) {
    printf_ex("error ADDRESS_OFFSET 0 is used for TLB noise reduction");
    exit(1);
  }
  struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  int allocatedMem = sizeof(struct l3pp);
  // Setup
  l3pp_t l3 = (l3pp_t)malloc(sizeof(struct l3pp));
  bzero(l3, sizeof(struct l3pp));
  this_app_state->l3 = l3;
  l3->max_es = max_es;

  printf_ex("l3->max_es %i\n", l3->max_es);

  // if (l3info != NULL)
  //  bcopy(l3info, &l3->l3info, sizeof(struct l3info));
  fillL3Info(app_state_ptr);
  l3->l3info.l3_threshold = L3_THRESHOLD_GLOBAL;
  L3_THRESHOLD_GLOBAL = l3_threshold;

  printf_ex("associativity:%i\n", l3->l3info.associativity);
  printf_ex("slices:%i\n", l3->l3info.slices);
  printf_ex("setsperslice:%i\n", l3->l3info.setsperslice);

  // Allocate cache buffer
  int bufsize;
  char *buffer = MAP_FAILED;

  if (buffer == MAP_FAILED) {
    bufsize = l3->l3info.bufsize;
    if(search_method == STOREFORWARDLEAKAGE){
      bufsize = this_app_state->storefor_buffer_size_bytes;
    }
    l3->groupsize = L3_SETS_PER_PAGE; // cause 4096/64 = 64

    buffer = mmap(NULL, bufsize, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,
                  -1, 0);
  }
  if (buffer == MAP_FAILED) {
    free(l3);
    return NULL;
  }
  l3->buffer = buffer;
  l3->l3info.bufsize = bufsize;

#ifdef BENCHMARKCONTRACT
  l3->size_es = vl_new();
  l3->contract_time = vl_new();
#endif

if(search_method == DEFAULT){
  printf_ex("default search method\n");
  // Create the cache map
  if (!probemap(l3)) {
    free(l3->buffer);
    free(l3);
    return NULL;
  }
}
else if(search_method == STOREFORWARDLEAKAGE){
  printf_ex("STOREFORWARDLEAKAGE search method\n");
  if (!probemap_storeforwardleakage(app_state_ptr)) {
    free(l3->buffer);
    free(l3);
    return NULL;
  }  
}
  printf_ex("ngroups:%i\n", l3->ngroups);

#ifdef BENCHMARKMODE
  return 0;
#endif

  // Allocate monitored set info
  // 2 * sizeof(uint32_t) per eviction_set
  l3->monitoredbitmap =
      (uint32_t *)calloc(l3->ngroups * l3->groupsize / 32, sizeof(uint32_t));
  allocatedMem += l3->ngroups * l3->groupsize / 32 * sizeof(uint32_t);

  // L3_SETS_PER_PAGE * sizeof(var) per eviction set
  l3->monitoredset = (int *)malloc(l3->ngroups * l3->groupsize * sizeof(int));
  allocatedMem += l3->ngroups * l3->groupsize * sizeof(int);
  l3->monitoredhead =
      (void **)malloc(l3->ngroups * l3->groupsize * sizeof(void *));
  allocatedMem += l3->ngroups * l3->groupsize * sizeof(void *);
  l3->nmonitored = 0;

  printf_ex("allocated %i Bytes\n", allocatedMem);

#ifdef BENCHMARKCONTRACT
  // printf benchmark result for contract
  for (int i = 0; i < vl_len(l3->size_es); i++) {
    printf_ex("%i: s:%u, t:%u\n", i, (uint32_t)vl_get(l3->size_es, i),
           (uint32_t)vl_get(l3->contract_time, i));
  }
#endif

  return l3;
}

/**
 * @brief Experimental l3_prepare for tests.
 * 
 * @param l3_threshold timer threshold (difference between cache hit or miss)
 * @param max_es Limits the number of "super" eviction-sets (each "super" eviction-set contains 64 evcition-sets)
 * @param bufsize Size of meomry buffer in bytes
 * @return l3pp_t 
 */
l3pp_t l3_create_only(void *app_state_ptr, int l3_threshold, int max_es, uint32_t bufsize) {
  if (ADDRESS_OFFSET == 0) {
    printf_ex("error ADDRESS_OFFSET 0 is used for TLB noise reduction");
    exit(1);
  }
    struct app_state *this_app_state = (struct app_state *)app_state_ptr;

  info = (struct timer_info *)malloc(sizeof(struct timer_info));
  bzero(info, sizeof(struct timer_info));

  int allocatedMem = sizeof(struct l3pp);
  // Setup
  l3pp_t l3 = (l3pp_t)malloc(sizeof(struct l3pp));
  bzero(l3, sizeof(struct l3pp));
  this_app_state->l3 = l3;
  l3->max_es = max_es;

  printf_ex("l3->max_es %i\n", l3->max_es);

  fillL3Info(app_state_ptr);
  L3_THRESHOLD_GLOBAL = l3_threshold;

  printf_ex("associativity:%i\n", l3->l3info.associativity);
  printf_ex("slices:%i\n", l3->l3info.slices);
  printf_ex("setsperslice:%i\n", l3->l3info.setsperslice);

  // Allocate cache buffer
  char *buffer = MAP_FAILED;

  if (buffer == MAP_FAILED) {
    l3->groupsize = L3_SETS_PER_PAGE; // cause 4096/64 = 64

    buffer = mmap(NULL, bufsize, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,
                  -1, 0);
  }
  if (buffer == MAP_FAILED) {
    free(l3);
    return NULL;
  }
  l3->buffer = buffer;
  l3->l3info.bufsize = bufsize;

  return l3;
}

/**
 * @brief Free used memory by l3pp struct
 * 
 * @param l3 Ptr to l3pp struct
 */
void l3_release(l3pp_t l3) {
  munmap(l3->buffer, l3->l3info.bufsize);
  free(l3->monitoredbitmap);
  free(l3->monitoredset);
  free(l3->monitoredhead);
  bzero(l3, sizeof(struct l3pp));
  free(l3);
}

/**
 * @brief Add a specific cache-set to the monitored-sets
 * 
 * @param l3 Ptr to l3pp struct
 * @param line cache-line in buffer (corresponds to a cache-set)
 * @return int 
 */
int l3_monitor(l3pp_t l3, int line) {
  if (line < 0 || line >= l3->ngroups * l3->groupsize)
    return 0;
  if (IS_MONITORED(l3->monitoredbitmap, line))
    return 0;
  SET_MONITORED(l3->monitoredbitmap, line);
  l3->monitoredset[l3->nmonitored] = line;
  l3->monitoredhead[l3->nmonitored] = sethead(l3, line);
  l3->nmonitored++;
  return 1;
}

/**
 * @brief Remove a specific cache-set from the monitored-sets
 * 
 * @param l3 Ptr to l3pp struct
 * @param line cache-line in buffer (corresponds to a cache-set)
 * @return int 
 */
int l3_unmonitor(l3pp_t l3, int line) {
  if (line < 0 || line >= l3->ngroups * l3->groupsize)
    return 0;
  if (!IS_MONITORED(l3->monitoredbitmap, line))
    return 0;
  UNSET_MONITORED(l3->monitoredbitmap, line);
  for (int i = 0; i < l3->nmonitored; i++)
    if (l3->monitoredset[i] == line) {
      --l3->nmonitored;
      l3->monitoredset[i] = l3->monitoredset[l3->nmonitored];
      l3->monitoredhead[i] = l3->monitoredhead[l3->nmonitored];
      break;
    }
  return 1;
}

/**
 * @brief Remove all cache-sets from the monitored-sets
 * 
 * @param l3 Ptr to l3pp struct
 */
void l3_unmonitorall(l3pp_t l3) {
  bzero(l3->monitoredbitmap,
        l3->ngroups * l3->groupsize / 32 * sizeof(uint32_t));
  l3->nmonitored = 0;
  for (int i = 0; i < l3->ngroups * l3->groupsize / 32; i++)
    l3->monitoredset[i] = 0;
}

/**
 * @brief Copy monitored-set to an int array
 * 
 * @param l3 Ptr to l3pp struct
 * @param lines Ptr to int array
 * @param nlines Number of monitored lines (cache-sets)
 * @return int 
 */
int l3_getmonitoredset(l3pp_t l3, int *lines, int nlines) {
  if (lines == NULL || nlines == 0)
    return l3->nmonitored;
  if (nlines > l3->nmonitored)
    nlines = l3->nmonitored;
  bcopy(l3->monitoredset, lines, nlines * sizeof(int));
  return l3->nmonitored;
}

/**
 * @brief Randomsize monitored-set
 * 
 * @param l3 Ptr to l3pp struct
 */
void l3_randomise(l3pp_t l3) {
  for (int i = 0; i < l3->nmonitored; i++) {
    int p = random() % (l3->nmonitored - i) + i;
    int t = l3->monitoredset[p];
    l3->monitoredset[p] = l3->monitoredset[i];
    l3->monitoredset[i] = t;
    void *vt = l3->monitoredhead[p];
    l3->monitoredhead[p] = l3->monitoredhead[i];
    l3->monitoredhead[i] = vt;
  }
}

/**
 * @brief prime-spam monitored cache-set (equivalent to optimized probe without time measurement)
 * 
 * @param l3 Ptr to l3pp struct
 */
void l3_probe_spam(l3pp_t l3) {
  for (int i = 0; i < l3->nmonitored; i++) {
    probe_only(l3->monitoredhead[i]);
  }
}

/**
 * @brief Back probe variant of l3_probe_spam
 * 
 * @param l3 Ptr to l3pp struct
 */
void l3_bprobe_spam(l3pp_t l3) {
  for (int i = 0; i < l3->nmonitored; i++) {
    probe_only(NEXTPTR(l3->monitoredhead[i]));
  }
}

/**
 * @brief Probe monitored cache-sets
 * 
 * @param l3 Ptr to l3pp struct
 * @param results Ptr to array for timer results
 * @param probetime Ptr to probe-operation
 */
void l3_probe(l3pp_t l3, RES_TYPE *results, uint32_t (*probetime)(void *pp)) {
  for (int i = 0; i < l3->nmonitored; i++) {
    int t = (*probetime)(l3->monitoredhead[i]);
    results[i] = t > RES_TYPE_MAX ? RES_TYPE_MAX : t;
  }
}

/**
 * @brief Back probe variant of l3_probe
 * 
 * @param l3 Ptr to l3pp struct
 * @param results Ptr to array for timer results
 * @param probetime Ptr to probe-operation
 */
void l3_bprobe(l3pp_t l3, RES_TYPE *results, uint32_t (*probetime)(void *pp)) {
  for (int i = 0; i < l3->nmonitored; i++) {
    int t = bprobetime(l3->monitoredhead[i], probetime);
    results[i] = t > RES_TYPE_MAX ? RES_TYPE_MAX : t;
  }
}

/**
 * @brief Count number of mem accesses which exceed L3_THRESHOLD_GLOBAL. (l3->monitoredhead[i] is the starting point of a ptr-chain with x entries. Measure access time for each of these x entries and count the cases where access time > L3_THRESHOLD_GLOBAL)
 * 
 * @param l3 Ptr to l3pp struct
 * @param results Number of samples aka prime-and-probe iterations
 */
void l3_probecount(l3pp_t l3, RES_TYPE *results) {
  for (int i = 0; i < l3->nmonitored; i++)
    results[i] = probecount(l3->monitoredhead[i]);
}

/**
 * @brief Back probe variant of l3_probecount
 * 
 * @param l3 Ptr to l3pp struct 
 * @param results Number of samples aka prime-and-probe iterations
 */
void l3_bprobecount(l3pp_t l3, RES_TYPE *results) {
  for (int i = 0; i < l3->nmonitored; i++)
    results[i] = bprobecount(l3->monitoredhead[i]);
}

// Returns the number of probed sets in the LLC
int l3_getSets(l3pp_t l3) { return l3->ngroups * l3->groupsize; }

// Returns the number slices
int l3_getSlices(l3pp_t l3) { return l3->l3info.slices; }

// Returns the LLC associativity
int l3_getAssociativity(l3pp_t l3) { return l3->l3info.associativity; }

/**
 * @brief Prime-and-probe each monitored cache-set nrecords times and save the measured times in results.
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @param results Arrays with time measurement results
 * @param slot Waiting time between two samples
 * @param type Type of probe-operation (look at get_probetime_by_type for more details)
 * @return int 
 */
int l3_repeatedprobe(l3pp_t l3, int nrecords, RES_TYPE *results, int slot,
                     int type) {
  assert(l3 != NULL);
  assert(results != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;
  uint32_t (*probetime)(void *pp) = get_probetime_by_type(type);

  int even = 1;
  int missed = 0;
  uint64_t prev_time = rdtscp64();
  for (int i = 0; i < nrecords; i++, results += len) {
    if (missed) {
      for (int j = 0; j < len; j++)
        results[j] = 0;
    } else {
      if (even)
        l3_probe(l3, results, probetime);
      else
        l3_bprobe(l3, results, probetime);
      even = !even;
    }
    if (slot > 0) {
      prev_time += slot;
      missed = slotwait(prev_time);
    }
  }
  return nrecords;
}

/**
 * @brief l3_repeatedprobe-version with reduced overhead (only for 1 monitored cache-set)
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @param results Arrays with time measurement results
 * @param type 
 * @return int 
 */
int l3_repeatedprobe_fast(l3pp_t l3, int nrecords, RES_TYPE *results,
                          int type) {
  assert(l3 != NULL);
  assert(results != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;
  if (len > 1)
    return -1;

  uint32_t (*probetime)(void *pp) = get_probetime_by_type(type);

  void *monitoredes1 = l3->monitoredhead[0];
  void *monitoredes1b = NEXTPTR(monitoredes1);

  int even = 1;
  for (int i = 0; i < nrecords;) {
    if (even) {
      results[++i] = (RES_TYPE)(*probetime)(monitoredes1);
    } else {
      results[++i] = (RES_TYPE)(*probetime)(monitoredes1b);
    }
    even = !even;
  }
  return nrecords;
}

/**
 * @brief Use prime-and-probe operation to slow down code (discard measurement)
 * 
 * @param l3 Ptr to l3pp struct 
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @return int 
 */
int l3_repeatedprobe_spam(l3pp_t l3, int nrecords) {
  assert(l3 != NULL);

  if (nrecords == 0)
    return 0;

  //uint32_t (*probetime)(void *pp) = get_probetime_by_type(type);

  int even = 1;
  for (int i = 0; i < nrecords; i++) {
      if (even)
        l3_probe_spam(l3);
      else
        l3_bprobe_spam(l3);
      even = !even;
  }
  return nrecords;
}

/**
 * @brief Experimental version of prime spam fast
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @return int 
 */
int l3_repeatedprobe_spam_fast_experimental(l3pp_t l3, int nrecords) {
  assert(l3 != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;
  if (len > 1)
    return -1;

  void *monitoredes1 = l3->monitoredhead[0];
  void *monitoredes1b = NEXTPTR(monitoredes1);

  void **ptr_arr = (void**)malloc(sizeof(void*) * 16);
  for(int i=0; i<16; i++){
    ptr_arr[i] = monitoredes1;
    monitoredes1 = LNEXT(monitoredes1);
  }

  //not working
  for (int i = 0; i < nrecords; i++) { 
    for(int j=0; j<16; j++){
      volatile void *k = (void*)LNEXT(ptr_arr[j]);
    }
    for(int j=15; j>=0; j--){
      volatile void *k = (void*)LNEXT(ptr_arr[j]);
    }
  }
  return nrecords;
}

/**
 * @brief Faster version of prim spam (reduced function calling overhead)
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @return int 
 */
int l3_repeatedprobe_spam_fast(l3pp_t l3, int nrecords) {
  assert(l3 != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;
  if (len > 1)
    return -1;

  void *monitoredes1 = l3->monitoredhead[0];
  void *monitoredes1b = NEXTPTR(monitoredes1);

  //int even = 1;
  for (int i = 0; i < nrecords; i++) { // i++, results+=len) {
    //if (even) {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(monitoredes1);
      probe_only_split_2(monitoredes1);
      //results[++i] = (RES_TYPE)(*probetime)(monitoredes1);
      //}
    //} else {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(NEXTPTR(monitoredes1));
      probe_only_split_2(monitoredes1b);
      //results[++i] = (RES_TYPE)(*probetime)(monitoredes1b);
      //}
    //}
    //even = !even;
  }
  return nrecords;
}

/**
 * @brief Prime spam with different prime types
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @param option option=0 => probe_only_split_2 with bprobe, option=1 => probe_only_split_2 without bprobe, option=2 => ptr_arr with bprobe, option=3 => ptr_arr with bprobe, option=4 => probe_only with bprobe, option=5 => probe_only without bprobe
 * @return int 
 */
int l3_repeatedprobe_spam_option(l3pp_t l3, int nrecords, int option) {
  assert(l3 != NULL);

  if (nrecords == 0)
    return 0;

  if (l3->nmonitored > 1)
  {
    // if(option != 2 && option != 3){
    //   option = 3;
    //   printf_ex("set option to 3!\n");
    // }
  }

  void *monitoredes1 = l3->monitoredhead[0];
  void *monitoredes1b = NEXTPTR(monitoredes1);

  int asso = 16;
  int ptr_arr_size = asso * l3->nmonitored;
  void** ptr_arr = (void**) malloc(sizeof(void*) * ptr_arr_size);
  for (int i = 0; i < l3->nmonitored; i++) {
      void* p = l3->monitoredhead[i];
      for(int j=0; j<asso; j++){
        ptr_arr[i*asso + j] = p;
        p = *((void **)p);
      }
  }

  for (int i = 0; i < l3->nmonitored; i++) {
      void* p = l3->monitoredhead[i];
      //get last ptr in chain
      for(int j=0; j<asso-1; j++){
        p = *((void **)p);
      }
      LNEXT(p) = l3->monitoredhead[(i+1)%l3->nmonitored];
      //shortcut
      //LNEXT(NEXTPTR(p)) = l3->monitoredhead[(i+1)%l3->nmonitored];
      //LNEXT(p) = NEXTPTR(l3->monitoredhead[(i-1+l3->nmonitored)%l3->nmonitored]);      
  }
  //l3_monitor should be called afterwards

  //sethead_prime_spam(l3, ptr_arr, ptr_arr_size);

  int ptr,ptr2,ptr3,ptr4;
  if(option == 0){ //probe_only_split_2 with bprobe
  //int even = 1;
    //if(l3->nmonitored == 1){
      for (int i = 0; i < nrecords; i++) {
        
        probe_only_split_2(monitoredes1);
        probe_only_split_2(monitoredes1b);
      }
    // } else{
    //   l3_repeatedprobe_spam(l3, nrecords);
    // }
  } else if(option == 1){ //probe_only_split_2 without bprobe
      //if(l3->nmonitored == 1){
        for (int i = 0; i < nrecords; i++) {
          probe_only_split_2_count(monitoredes1, ptr_arr_size/2);
          //probe_only_split_2(monitoredes1);
        }
      // } else{
      //   for (int i = 0; i < nrecords; i++) {
      //     l3_probe_spam(l3);
      //   }
      // }
  } else if(option == 2){ //ptr_arr with bprobe
    for (int i = 0; i < nrecords; i++) {
      for(int i=0; i<ptr_arr_size; i++){
        ptr ^= *((int*)ptr_arr[i]);
      }
      for(int i=ptr_arr_size-1; i>=0; i--){
        ptr ^= *((int*)ptr_arr[i]);
      }
    }
  } else if(option == 3){ //ptr_arr without bprobe
    for (int i = 0; i < nrecords; i++) {
      for(int i=0; i<ptr_arr_size; i++){
        ptr ^= *((int*)ptr_arr[i]);
      }
    }
  } else if(option == 4){ //probe_only with bprobe
    for (int i = 0; i < nrecords; i++) {
      probe_only(monitoredes1);
      probe_only(monitoredes1b);
    }
  } else if(option == 5){ //probe_only without bprobe
    for (int i = 0; i < nrecords; i++) {
      probe_only(monitoredes1);
    }
  } else if(option == 32){ //ptr_arr without bprobe
    for (int i = 0; i < nrecords; i++) {
      for(int i=0; i<ptr_arr_size/2; i++){
        ptr ^= *((int*)ptr_arr[i]);
        ptr2 ^= *((int*)ptr_arr[ptr_arr_size/2+i]);
      }
    }
  }
  else if(option == 34){ //ptr_arr without bprobe
    for (int i = 0; i < nrecords; i++) {
      for(int i=0; i<ptr_arr_size/2; i++){
        ptr ^= *((int*)ptr_arr[i]);
        ptr2 ^= *((int*)ptr_arr[ptr_arr_size/4+i]);
        ptr3 ^= *((int*)ptr_arr[ptr_arr_size/2+i]);
        ptr4 ^= *((int*)ptr_arr[ptr_arr_size*3/4+i]);
      }
    }
  }
    else if(option == 35){ //ptr_arr without bprobe
    for (int i = 0; i < nrecords; i++) {
      void** ptr_arr2 = ptr_arr + ptr_arr_size/4;
      void** ptr_arr3 = ptr_arr + ptr_arr_size/2;
      void** ptr_arr4 = ptr_arr + ptr_arr_size*3/4;
      for(int i=0; i<ptr_arr_size/2; i++){
        ptr ^= *((int*)ptr_arr[i]);
        ptr2 ^= *((int*)ptr_arr2[i]);
        ptr3 ^= *((int*)ptr_arr3[i]);
        ptr4 ^= *((int*)ptr_arr4[i]);
      }
    }
  }
  else if(option == 31){ //ptr_arr without bprobe
    for (int i = 0; i < nrecords; i++) {
      for(int i=0; i<ptr_arr_size/2; i++){
        *((int*)ptr_arr[i]);
      }
    }
  }

  free(ptr_arr);
  return ptr^ptr2^ptr3^ptr4;
}

/**
 * @brief Cycles through all memory-blocks in a eviction-set access them and count accesses with (accesstime > L3_THRESHOLD_GLOBAL)
 * 
 * @param l3 Ptr to l3pp struct
 * @param nrecords Number of samples aka prime-and-probe iterations
 * @param results Arrays with time measurement results
 * @param slot Waiting time between two samples
 * @return int 
 */
int l3_repeatedprobecount(l3pp_t l3, int nrecords, RES_TYPE *results,
                          int slot) {
  assert(l3 != NULL);
  assert(results != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;

  int even = 1;
  int missed = 0;
  uint64_t prev_time = rdtscp64();
  for (int i = 0; i < nrecords; i++, results += len) {
    if (missed) {
      for (int j = 0; j < len; j++)
        results[j] = -1;
    } else {
      if (even)
        l3_probecount(l3, results);
      else
        l3_bprobecount(l3, results);
      even = !even;
    }
    if (slot > 0) {
      prev_time += slot;
      missed = slotwait(prev_time);
    }
  }
  return nrecords;
}
