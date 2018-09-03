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

#define CHECKTIMES 16
#define FACTORDEBUG 20
#define FACTORPRINT 10
#ifdef WASM
#define FACTORNORMAL 3
#else
#define FACTORNORMAL 1
#endif

int L3_THRESHOLD = 10000;
int L3_THRESHOLD_OFFSET = 0;

/*
 * Intel documentation still mentiones one slice per core, but
 * experience shows that at least some Skylake models have two
 * smaller slices per core.
 * When probing the cache, we can use the smaller size - this will
 * increase the probe time but for huge pages, where we use
 * the slice size, the probe is fast and the increase is not too
 * significant.
 * When using the PTE maps, we need to know the correct size and
 * the correct number of slices.  This means that, currently and
 * without user input, PTE is not guaranteed to work.
 * So, on a practical note, L3_GROUPSIZE_FOR_HUGEPAGES is the
 * smallest slice size we have seen; L3_SETS_PER_SLICE is the
 * default for the more common size.  If we learn how to probe
 * the slice size we can get rid of this mess.
 */
#define L3_SETS_PER_SLICE 2048

// The number of cache sets in each page
#define L3_SETS_PER_PAGE 64

// offset for each address in the memory pool
// between 0 and 4000
#define ADDRESS_OFFSET 2048

// buffer for memoryblocks is multiple of cache size
// 2 size enough, remember virtual
#define CACHE_SIZE_MULTI 2

// size(es) <= L3_ASSOCIATIVITY * MAX_L3_ASSOCIATIVITY_DIFF
#define MAX_L3_ASSOCIATIVITY_DIFF 0

// should be MAX_INT, set lower for debugging purposes
#define MAX_ES 1

// experiments shows: valid es => after first contract => vl_len(es) < 900
#define MAX_SIZE_AFTER_FIRST_CONTRACT 900

// experiments shows: valid es => after first contract => vl_len(es) < 100
#define MAX_SIZE_AFTER_SECOND_CONTRACT 100

// experiments shows: valid es => max three contract calls
#define MAX_CONTRACT_CALLS 3

// choose percentage of availible mem blocks in the pool before first es testing
#define EXPAND_START_VALUE_FACTOR 0.3

// try to delete mulipte elements from es in contract before es testing
// e.g. vl_len(es) = 1000 & CONTRACT_FIRST_DEL_FACTOR=0.02 => del 20 elements at
// once
#define CONTRACT_FIRST_DEL_FACTOR 0.02
#define CONTRACT_SECOND_DEL_FACTOR 0.005

#define FAIL_MAX 1000
// decrease L3_THRESHOLD_OFFSET to del more elements in the contract phase
#define TOO_BIG_TRIGGER_VALUE 20
// decrease L3_THRESHOLD_OFFSET to del less elements in the contract phase
#define TOO_SMALL_TRIGGER_VALUE 20

#define DEBUG_CHANGE_THRESHOLD

#ifdef WASM
// ifdef => test eviction set multiple times after contract phase
#define AFTERCONTRACTTEST

// ifdef => test correctness of conctract phase, test es without one member for
// each member
#define ONEOUTTEST

// print debug stuff for one out test and after contract test
#define DEBUG_TEST_PRINT 0

#define EXPAND_ITERATIONS 20
#define CONTRACT_ITERATIONS 1
#define COLLECT_ITERATIONS 1
#else
#define EXPAND_ITERATIONS 1
#define CONTRACT_ITERATIONS 1
#define COLLECT_ITERATIONS 1
#endif

#define IS_MONITORED(monitored, setno)                                         \
  ((monitored)[(setno) >> 5] & (1 << ((setno)&0x1f)))
#define SET_MONITORED(monitored, setno)                                        \
  ((monitored)[(setno) >> 5] |= (1 << ((setno)&0x1f)))
#define UNSET_MONITORED(monitored, setno)                                      \
  ((monitored)[(setno) >> 5] &= ~(1 << ((setno)&0x1f)))

#define SLICE_MASK_0 0x1b5f575440UL
#define SLICE_MASK_1 0x2eb5faa880UL
#define SLICE_MASK_2 0x3cccc93100UL

// struct l3pp {
//   struct l3info l3info;
//   union cpuid cpuidInfo;

//   // To reduce probe time we group sets in cases that we know that a group of
//   consecutive cache lines will
//   // always map to equivalent sets. In the absence of user input (yet to be
//   implemented) the decision is:
//   // Non linear mappings - 1 set per group (to be implemeneted)
//   // Huge pages - L3_SETS_PER_SLICE sets per group (to be impolemented)
//   // Otherwise - L3_SETS_PER_PAGE sets per group.
//   int ngroups;
//   int groupsize;
//   vlist_t *groups;
//   void *buffer;
//   uint32_t *monitoredbitmap;
//   int *monitoredset;
//   int nmonitored;
//   void **monitoredhead;
// };

struct timer_info *info;

static int parity(uint64_t v) {
  v ^= v >> 1;
  v ^= v >> 2;
  v = (v & 0x1111111111111111UL) * 0x1111111111111111UL;
  return (v >> 60) & 1;
}

static int addr2slice_linear(uintptr_t addr, int slices) {
  int bit0 = parity(addr & SLICE_MASK_0);
  int bit1 = parity(addr & SLICE_MASK_1);
  int bit2 = parity(addr & SLICE_MASK_2);
  return ((bit2 << 2) | (bit1 << 1) | bit0) & (slices - 1);
}

static uintptr_t getphysaddr(void *p) {
#ifdef __linux__
  static int fd = -1;

  if (fd < 0) {
    fd = open("/proc/self/pagemap", O_RDONLY);
    if (fd < 0)
      return 0;
  }
  uint64_t buf;
  memaccess(p);
  uintptr_t intp = (uintptr_t)p;
  int r = pread(fd, &buf, sizeof(buf), ((uintptr_t)p) / 4096 * sizeof(buf));

  return (buf & ((1ULL << 54) - 1)) << 12 | ((uintptr_t)p & 0x3ff);
#else
  return 0;
#endif
}
static void fillL3Info(l3pp_t l3) {
  // l3-cache i7-4770: 16-way-ass, 8192sets, 4slices =>
  // 4(ass)+13(sets)+6(line)=23bits (8MiB) l3-cache i3-5010U: 12-way-ass,
  // 4096sets, 3MiB like 16-way-ass and 4MiB => 4(ass)+12(sets)+6(line)=22bits
  // (4MiB) works also for other CPUs

  l3->l3info.associativity = 16;
  l3->cpuidInfo.cacheInfo.sets = 8192;
  l3->l3info.slices = 4;
  l3->l3info.setsperslice = l3->cpuidInfo.cacheInfo.sets / l3->l3info.slices;
  l3->l3info.bufsize = l3->l3info.associativity * l3->l3info.slices *
                       l3->l3info.setsperslice * L3_CACHELINE *
                       CACHE_SIZE_MULTI;

  // bufsize = cachesize * factor

  // loadL3cpuidInfo(l3);
  // if (l3->l3info.associativity == 0)
  //   l3->l3info.associativity = l3->cpuidInfo.cacheInfo.associativity + 1;
  // if (l3->l3info.slices == 0) {
  //   if (l3->l3info.setsperslice == 0)
  //     l3->l3info.setsperslice = L3_SETS_PER_SLICE;
  //   l3->l3info.slices = (l3->cpuidInfo.cacheInfo.sets + 1)/
  //   l3->l3info.setsperslice;
  // }
  // if (l3->l3info.setsperslice == 0)
  //   l3->l3info.setsperslice = (l3->cpuidInfo.cacheInfo.sets +
  //   1)/l3->l3info.slices;
  // if (l3->l3info.bufsize == 0) {
  //   l3->l3info.bufsize = l3->l3info.associativity * l3->l3info.slices *
  //   l3->l3info.setsperslice * L3_CACHELINE * 2; if (l3->l3info.bufsize < 10 *
  //   1024 * 1024)
  //     l3->l3info.bufsize = 10 * 1024 * 1024;
  // }
}

// extend version: change between no bprobe and direct access to all 16 add or
// bprobe and access to 8 add with distance 2
void *sethead_ex(l3pp_t l3, int set,
                 int bprobe) { // vlist_t list, int count, int offset) {
  // load eviction set
  vlist_t list = l3->groups[set / l3->groupsize];

  int count = l3->l3info.associativity;
  if (count == 0 || vl_len(list) < count)
    count = vl_len(list);

  int offset = (set % l3->groupsize) * L3_CACHELINE;

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
    }
  }

  return OFFSET(vl_get(list, 0), offset);
}

void *sethead(l3pp_t l3, int set) { return sethead_ex(l3, set, 1); }

void prime(void *pp, int reps) { walk((void *)pp, reps); }

#define str(x) #x
#define xstr(x) str(x)

static int timedwalk(void *list, register void *candidate, int walk_size,
                     int print, vlist_t es) {
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
  int a = memaccess(candidate);
  for (int i = 0;
       i < CHECKTIMES *
               (debug ? FACTORDEBUG : (print ? FACTORPRINT : FACTORNORMAL));
       i++) {

    // if(print)
    //   or_flush = flush_l3(buffer,pages,block_size);

    // walk(list,20); was default why???
#ifdef WASM
    or_walk = walk(list, walk_size);
    // walk_through(list);
#else
    or_walk = walk(list, 20);
#endif
    // void *p = LNEXT(c2);

    // try to reduce TLB noise (drive-by cache paper)
    // access memory in the same page
    // use page start (last 12 bits zero)
    // maybe collide with ADDRESS_OFFSET
    void *candiate_page = (void *)(((uintptr_t)candidate >> 12) << 12);
    memaccess(candiate_page);

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

static int checkevict(vlist_t es, void *candidate, int walk_size, int print) {
  if (vl_len(es) == 0)
    return 0;
  if (walk_size == 0)
    printf_ex("walk_size == 0\n");
  for (int i = 0; i < vl_len(es); i++)
    LNEXT(vl_get(es, i)) = vl_get(es, (i + 1) % vl_len(es));
  int timecur = timedwalk(vl_get(es, 0), candidate, walk_size, print, es);
  // printf_ex("$%i ", timecur);
  // if(timecur > (L3_THRESHOLD + L3_THRESHOLD_OFFSET))
  // printf_ex("timecur %i\n",timecur);
  return timecur;
}

static int checkevict_safe(vlist_t es, void *candidate, int walk_size,
                           int print, int proofs) {
  if (proofs <= 0) {
    printf_ex("proofs <= 0. set proofs = 1\n");
    proofs = 1;
  }
  int counter = 0;
  for (int i = 0; i < proofs; i++) {
    if (checkevict(es, candidate, walk_size, print) <=
        (L3_THRESHOLD + L3_THRESHOLD_OFFSET))
      break;
    counter++;
    if (i >= 1) {
      // checkevict(es, candidate, walk_size, 1);
    }
  }
  return counter == proofs;
}

static void access_es(vlist_t es) {
  if (vl_len(es) == 0)
    return;
  for (int i = 0; i < vl_len(es); i++)
    LNEXT(vl_get(es, i)) = vl_get(es, (i + 1) % vl_len(es));
  walk(vl_get(es, 0), vl_len(es));
}

static void expand_test(vlist_t es, void *current) {
  for (int a = 0; a < 10; a++) {
    access_es(es);
    for (int i = 0; i < 2; i++) {
      printf_ex("diff%i: %" PRIu32 " ", i,
             memaccesstime_abs_double_access(current));
    }
    putchar('\n');
  }
}

static void *expand_storefor(vlist_t es, vlist_t candidates) {
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

static void *expand(vlist_t es, vlist_t candidates) {
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

static void contract(vlist_t es, vlist_t candidates, void *current) {
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

static int contract_multiple(vlist_t es, vlist_t candidates, void *current,
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

static void contract_advanced(vlist_t es, vlist_t candidates, void *current,
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

// do not use collected memory blocks further
static int collect(vlist_t es, vlist_t candidates /*, vlist_t set*/) {
  int deleted = 0;
  for (int i = vl_len(candidates); i--;) {
    void *p = vl_del(candidates, i);
    if (checkevict_safe(es, p, vl_len(es), 0, COLLECT_ITERATIONS)) {
      // vl_push(set, p);
      deleted++;
    } else {
      vl_push(candidates, p);
    }
  }
  return deleted;
}

#define DEBUG

// get l3 struct and list of addresses with page size gaps
// tries to find evicitions sets
vlist_t map(l3pp_t l3, vlist_t lines, int storefor_mode) {
#ifdef DEBUG
  printf_ex("lines aka memory-blocks %d\n", vl_len(lines));
  printf_ex("---------------------INFO END--------------------------\n");
#endif // DEBUG
  uint64_t time_expand = 0, time_contract = 0, time_collect = 0,
           time_datahandling = 0;
  uint32_t before = 0;
  vlist_t groups = vl_new();
  vlist_t es = vl_new();
  int nlines = vl_len(lines);
  int fail = 0, too_big = 0, too_small = 0;
  while (vl_len(lines)) {

    if (too_big > TOO_BIG_TRIGGER_VALUE ||
        too_small > TOO_SMALL_TRIGGER_VALUE) {
      if (too_big > TOO_BIG_TRIGGER_VALUE) {
        // L3_THRESHOLD_OFFSET--;
      } else {
        // L3_THRESHOLD_OFFSET++;
      }
#ifdef DEBUG_CHANGE_THRESHOLD
      // printf_ex("toobig %i, toosmall %i\n", too_big, too_small);
      // printf_ex("L3_THRESHOLD + L3_THRESHOLD_OFFSET now: %i\n", L3_THRESHOLD +
      // L3_THRESHOLD_OFFSET);
#endif
      too_big = 0;
      too_small = 0;
    }

    assert(vl_len(es) == 0);
#ifdef DEBUG
    int d_l1 = vl_len(lines);
#endif // DEBUG
    if (fail > FAIL_MAX) {
      printf_ex("to many failed atemps, es search canceled!\n");
      break;
    }

    before = rdtscp();
    void *c;
    //if(storefor_mode)
    //  c = expand_storefor(es, lines);
    //else
      c = expand(es, lines);
    time_expand += (uint64_t)get_diff(before, rdtscp());

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
#endif // DEBUG
      fail += 50;
      if(storefor_mode){
        fail = FAIL_MAX+1;
      }
      continue;
      time_datahandling += (uint64_t)get_diff(before, rdtscp());
    }

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
      contract_advanced(es, lines, c, l3->l3info.associativity);
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
        break;
      }
      if (i == 1 && vl_len(es) >= MAX_SIZE_AFTER_SECOND_CONTRACT) {
#ifdef DEBUG_CONTRACT
        printf_ex("after first contract call => vl_len(es) >= %i => break\n",
               MAX_SIZE_AFTER_SECOND_CONTRACT);
#endif
        break;
      }
      size_old = vl_len(es);
    }
#else
    before = rdtscp();
    contract(es, lines, c);
    contract(es, lines, c);
    contract(es, lines, c);
    time_contract += (uint64_t)get_diff(before, rdtscp());
#endif

    before = rdtscp();
    // if(vl_len(es) < l3->l3info.associativity){
    //   printf_ex("warning vl_len(es)=%i < ass=%i!\n", vl_len(es),
    //   l3->l3info.associativity);
    // }
    int test_failed = 0;
    if (vl_len(es) <= l3->l3info.associativity + MAX_L3_ASSOCIATIVITY_DIFF &&
        vl_len(es) >= l3->l3info.associativity) {
#ifdef AFTERCONTRACTTEST
#if DEBUG_TEST_PRINT == 1
      printf_ex("after contract es size:%i\n", vl_len(es));
      printf_ex("evict ");
#endif
      for (int i = 0; i < 10; i++) {
        if (checkevict(es, c, vl_len(es), DEBUG_TEST_PRINT) <= L3_THRESHOLD)
          test_failed = 1;
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
      for (int i = 0; i < vl_len(es); i++) {
        void *element = vl_del(es, i);
        if (checkevict(es, c, vl_len(es), DEBUG_TEST_PRINT) > L3_THRESHOLD)
          oneouttest_failed++;
        vl_insert(es, i, element);
      }
      if (oneouttest_failed > 3)
        test_failed = 1;
#if DEBUG_TEST_PRINT == 1
      putchar('\n');
#endif
#endif // ONEOUTTEST
    }

#ifdef DEBUG
    int d_l3 = vl_len(es);
#endif // DEBUG

    // rewind if size(es) do not match associativity
    if (vl_len(es) > l3->l3info.associativity + MAX_L3_ASSOCIATIVITY_DIFF ||
        vl_len(es) < l3->l3info.associativity - 4 || test_failed) {
      if (vl_len(es) > l3->l3info.associativity + MAX_L3_ASSOCIATIVITY_DIFF) {
        too_big++;
      } else {
        too_small++;
      }

      while (vl_len(es))
        vl_push(lines, vl_del(es, 0));

      vl_push(lines, c);
#ifdef DEBUG
      printf_ex("set %3d: lines: %4d expanded: %4d contracted: %2d ",
             vl_len(groups), d_l1, d_l2, d_l3);
      if (test_failed)
        printf_ex("test failed\n");
      else
        printf_ex("contract failed\n");
#endif // DEBUG
      fail++;
      continue;
    }
    time_datahandling += (uint64_t)get_diff(before, rdtscp());

    too_small = 0;
    too_big = 0;
    fail = 0;
    vlist_t set = vl_new();
    // do not add collected memory blocks to es
    // vl_push(set, c);
    before = rdtscp();
    int deleted = collect(es, lines /*, set*/);
    time_collect += (uint64_t)get_diff(before, rdtscp());

    before = rdtscp();
    while (vl_len(es))
      vl_push(set, vl_del(es, 0));
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
  }

  vl_free(es);
  uint64_t time_sum =
      time_expand + time_contract + time_collect + time_datahandling;
  printf_ex(
      "runtime expand: %f, contract: %f, collect %f, datahandling %f(%" PRId64
      ")\n",
      (double)time_expand / time_sum, (double)time_contract / time_sum,
      (double)time_collect / time_sum, (double)time_datahandling / time_sum,
      time_datahandling);
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
    for (int offset = 0; offset < PAGE_SIZE / L3_CACHELINE; offset++) {
      int inner_page_add = offset << L3_CACHELINE_BITS;
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

// take buffer in l3 struct and try to create eviction sets
int probemap(l3pp_t l3) {
  if ((l3->l3info.flags & L3FLAG_NOPROBE) != 0)
    return 0;
  printf_ex("l3info.bufsize:%i\n", l3->l3info.bufsize);
  printf_ex("l3->groupsize: %i\n", l3->groupsize);
  printf_ex("L3_CACHELINE: %i\n", L3_CACHELINE);
  vlist_t pages = vl_new();
  for (int i = 0; i < l3->l3info.bufsize; i += l3->groupsize * L3_CACHELINE)
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

l3pp_t l3_prepare(l3info_t l3info, int l3_threshold, int max_es) {
  if (ADDRESS_OFFSET == 0) {
    printf_ex("error ADDRESS_OFFSET 0 is used for TLB noise reduction");
    exit(1);
  }

  info = (struct timer_info *)malloc(sizeof(struct timer_info));
  bzero(info, sizeof(struct timer_info));

  int allocatedMem = sizeof(struct l3pp);
  // Setup
  l3pp_t l3 = (l3pp_t)malloc(sizeof(struct l3pp));
  bzero(l3, sizeof(struct l3pp));
  l3->max_es = max_es;

  printf_ex("l3->max_es %i\n", l3->max_es);

  // if (l3info != NULL)
  //  bcopy(l3info, &l3->l3info, sizeof(struct l3info));
  fillL3Info(l3);
  l3->l3info.l3_threshold = L3_THRESHOLD;
  L3_THRESHOLD = l3_threshold;

  printf_ex("associativity:%i\n", l3->l3info.associativity);
  printf_ex("slices:%i\n", l3->l3info.slices);
  printf_ex("setsperslice:%i\n", l3->l3info.setsperslice);

  // Allocate cache buffer
  int bufsize;
  char *buffer = MAP_FAILED;

  if (buffer == MAP_FAILED) {
    bufsize = l3->l3info.bufsize;
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

  // Create the cache map
  if (!probemap(l3)) {
    free(l3->buffer);
    free(l3);
    return NULL;
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

l3pp_t l3_create_only(int l3_threshold, int max_es, uint32_t bufsize) {
  if (ADDRESS_OFFSET == 0) {
    printf_ex("error ADDRESS_OFFSET 0 is used for TLB noise reduction");
    exit(1);
  }

  info = (struct timer_info *)malloc(sizeof(struct timer_info));
  bzero(info, sizeof(struct timer_info));

  int allocatedMem = sizeof(struct l3pp);
  // Setup
  l3pp_t l3 = (l3pp_t)malloc(sizeof(struct l3pp));
  bzero(l3, sizeof(struct l3pp));
  l3->max_es = max_es;

  printf_ex("l3->max_es %i\n", l3->max_es);

  fillL3Info(l3);
  L3_THRESHOLD = l3_threshold;

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

void l3_release(l3pp_t l3) {
  munmap(l3->buffer, l3->l3info.bufsize);
  free(l3->monitoredbitmap);
  free(l3->monitoredset);
  free(l3->monitoredhead);
  bzero(l3, sizeof(struct l3pp));
  free(l3);
}

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

void l3_unmonitorall(l3pp_t l3) {
  bzero(l3->monitoredbitmap,
        l3->ngroups * l3->groupsize / 32 * sizeof(uint32_t));
  l3->nmonitored = 0;
  for (int i = 0; i < l3->ngroups * l3->groupsize / 32; i++)
    l3->monitoredset[i] = 0;
}

int l3_getmonitoredset(l3pp_t l3, int *lines, int nlines) {
  if (lines == NULL || nlines == 0)
    return l3->nmonitored;
  if (nlines > l3->nmonitored)
    nlines = l3->nmonitored;
  bcopy(l3->monitoredset, lines, nlines * sizeof(int));
  return l3->nmonitored;
}

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

void l3_probe_spam(l3pp_t l3) {
  for (int i = 0; i < l3->nmonitored; i++) {
    probe_only(l3->monitoredhead[i]);
  }
}

void l3_probe(l3pp_t l3, RES_TYPE *results, uint32_t (*probetime)(void *pp)) {
  for (int i = 0; i < l3->nmonitored; i++) {
    int t = (*probetime)(l3->monitoredhead[i]);
    results[i] = t > RES_TYPE_MAX ? RES_TYPE_MAX : t;
  }
}

void l3_bprobe_spam(l3pp_t l3) {
  for (int i = 0; i < l3->nmonitored; i++) {
    probe_only(NEXTPTR(l3->monitoredhead[i]));
  }
}

void l3_bprobe(l3pp_t l3, RES_TYPE *results, uint32_t (*probetime)(void *pp)) {
  for (int i = 0; i < l3->nmonitored; i++) {
    int t = bprobetime(l3->monitoredhead[i], probetime);
    results[i] = t > RES_TYPE_MAX ? RES_TYPE_MAX : t;
  }
}

void l3_probecount(l3pp_t l3, RES_TYPE *results) {
  for (int i = 0; i < l3->nmonitored; i++)
    results[i] = probecount(l3->monitoredhead[i]);
}

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
  // int monitoredes2 = l3->monitoredhead[1];

  int even = 1;
  for (int i = 0; i < nrecords;) { // i++, results+=len) {
    if (even) {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(monitoredes1);
      results[++i] = (RES_TYPE)(*probetime)(monitoredes1);
      //}
    } else {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(NEXTPTR(monitoredes1));
      results[++i] = (RES_TYPE)(*probetime)(monitoredes1b);
      //}
    }
    even = !even;
  }
  return nrecords;
}

int l3_repeatedprobe_spam_fast(l3pp_t l3, int nrecords) {
  assert(l3 != NULL);

  if (nrecords == 0)
    return 0;

  int len = l3->nmonitored;
  if (len > 1)
    return -1;

  void *monitoredes1 = l3->monitoredhead[0];
  void *monitoredes1b = NEXTPTR(monitoredes1);
  // int monitoredes2 = l3->monitoredhead[1];

  //int even = 1;
  for (int i = 0; i < nrecords; i++) { // i++, results+=len) {
    //if (even) {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(monitoredes1);
      probe_only(monitoredes1);
      //results[++i] = (RES_TYPE)(*probetime)(monitoredes1);
      //}
    //} else {
      // for (int i = 0; i < len; i++) {
      // results[++i] = (RES_TYPE)probetime(NEXTPTR(monitoredes1));
      probe_only(monitoredes1b);
      //results[++i] = (RES_TYPE)(*probetime)(monitoredes1b);
      //}
    //}
    //even = !even;
  }
  return nrecords;
}

// cycles through all memory-blocks in a eviction-set
// access them and count accesses with (accesstime > L3_THRESHOLD)
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
