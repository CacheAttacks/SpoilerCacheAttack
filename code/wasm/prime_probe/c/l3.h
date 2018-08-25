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

#ifndef __L3_H__
#define __L3_H__ 1

struct timer_info *info;

#define LNEXT(t) (*(void **)(t))
#define OFFSET(p, o) ((void *)((uintptr_t)(p) + (o)))
#define NEXTPTR(p) (OFFSET((p), sizeof(void *)))

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

typedef uint32_t (*p_probetime)(void *);

l3pp_t l3_prepare(l3info_t l3info, int L3_THRESHOLD, int max_es);
void l3_release(l3pp_t l3);

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

int l3_repeatedprobe_fast(l3pp_t l3, int nrecords, RES_TYPE *results, int type);
int l3_repeatedprobe(l3pp_t l3, int nrecords, RES_TYPE *results, int slot,
                     int type);
int l3_repeatedprobecount(l3pp_t l3, int nrecords, RES_TYPE *results, int slot);

#endif // __L3_H__
