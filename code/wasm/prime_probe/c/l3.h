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

#ifndef __L3_H__
#define __L3_H__ 1

struct timer_info *info;

#define LNEXT(t) (*(void **)(t))
#define OFFSET(p, o) ((void *)((uintptr_t)(p) + (o)))
#define NEXTPTR(p) (OFFSET((p), sizeof(void *)))

#define CHECKTIMES 16
#define FACTORDEBUG 20
#define FACTORPRINT 10
#ifdef WASM
#define FACTORNORMAL 1
#else
#define FACTORNORMAL 1
#endif

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
#define L3_SETS_PER_SLICE L3_CACHE_SETS / L3_CACHE_SLICES

// The number of cache sets in each page
#define L3_SETS_PER_PAGE PAGE_SIZE / L3_CACHE_LINE_SIZE

// offset for each address in the memory pool
// between 0 and 4000
#define ADDRESS_OFFSET 2048

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
#define EXPAND_START_VALUE_FACTOR 0.6

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

//#define DEBUG_CHANGE_THRESHOLD

#ifdef WASM
// ifdef => test eviction set multiple times after contract phase
#define AFTERCONTRACTTEST

// ifdef => test correctness of conctract phase, test es without one member for
// each member
#define ONEOUTTEST

//#define REUSE_CONTRACT_ENTRIES

// print debug stuff for one out test and after contract test
#define DEBUG_TEST_PRINT 0

//repeat iterations times to reduce possible errors
//breaks if the results lead to a contradiction
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


typedef void (*l3progressNotification_t)(int count, int est, void *data);
struct l3info
{
  int associativity;
  int slices;
  int setsperslice;
  int bufsize;
  int flags;
  l3progressNotification_t progressNotification;
  void *progressNotificationData;
  int l3_threshold;
  int l3_cache_size_multi;
};

typedef struct l3pp *l3pp_t;
typedef struct l3info *l3info_t;

struct l3pp
{
  struct l3info l3info;
  union cpuid cpuidInfo;

  // To reduce probe time we group sets in cases that we know that a group of
  // consecutive cache lines will always map to equivalent sets. In the absence
  // of user input (yet to be implemented) the decision is: Non linear mappings
  // - 1 set per group (to be implemeneted) Huge pages - L3_SETS_PER_SLICE sets
  // per group (to be impolemented) Otherwise - L3_SETS_PER_PAGE sets per group.
  int ngroups;
  int groupsize;
  vlist_t *groups;
  vlist_t collect_groups;
  void *buffer;
  uint32_t *monitoredbitmap;
  int *monitoredset;
  int nmonitored;
  void **monitoredhead;
  int max_es;
#ifdef BENCHMARKCONTRACT
  vlist_t size_es;
  vlist_t contract_time;
#endif
};

#define L3FLAG_NOHUGEPAGES 0x01
#define L3FLAG_USEPTE 0x02
#define L3FLAG_NOPROBE 0x04

void set_timer_info();

typedef uint32_t (*p_probetime)(void *);

enum search_methods { DEFAULT, STOREFORWARDLEAKAGE };

int checkevict_safe(vlist_t es, void *candidate, int walk_size,
                           int print, int proofs);

void print_parameters(void *app_state_ptr);

l3pp_t l3_prepare(void *app_state_ptr, l3info_t l3info, int l3_threshold, int max_es, enum search_methods search_method);
l3pp_t l3_create_only(void *app_state_ptr, int l3_threshold, int max_es, uint32_t bufsize);
void l3_release(l3pp_t l3);

vlist_t map(l3pp_t l3, vlist_t lines, int storefor_mode);
vlist_t expand_groups(vlist_t groups);

// Returns the number of probed sets in the LLC
int l3_getSets(l3pp_t l3);

// Returns the number slices
int l3_getSlices(l3pp_t l3);

// Returns the LLC associativity
int l3_getAssociativity(l3pp_t l3);

int l3_monitor(l3pp_t l3, int line);
void l3_unmonitorall(l3pp_t l3);
int l3_unmonitor(l3pp_t l3, int line);
int l3_getmonitoredset(l3pp_t l3, int *lines, int nlines);

void l3_randomise(l3pp_t l3);

void l3_probe(l3pp_t l3, RES_TYPE *results, p_probetime func_ptr);
void l3_bprobe(l3pp_t l3, RES_TYPE *results, p_probetime func_ptr);
void l3_probecount(l3pp_t l3, RES_TYPE *results);
void l3_bprobecount(l3pp_t l3, RES_TYPE *results);

int l3_repeatedprobe_spam(l3pp_t l3, int nrecords);
int l3_repeatedprobe_fast(l3pp_t l3, int nrecords, RES_TYPE *results, int type);
int l3_repeatedprobe_spam_fast(l3pp_t l3, int nrecords);
int l3_repeatedprobe_spam_option(l3pp_t l3, int nrecords, int option);
int l3_repeatedprobe_spam_fast_experimental(l3pp_t l3, int nrecords);

int l3_repeatedprobe(l3pp_t l3, int nrecords, RES_TYPE *results, int slot,
                     int type);
int l3_repeatedprobecount(l3pp_t l3, int nrecords, RES_TYPE *results, int slot);

#endif // __L3_H__
