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

#ifndef __LOW_H__
#define __LOW_H__

#include "config.h"

// warm up timers before measurement operation
#define WARMUP

#ifdef WASM
#include "SABcounter.h"
#endif

#include <sys/mman.h>

//#define L3_THRESHOLD 50

//type for prime-and-probe measurement results
#define RES_TYPE uint32_t       // uint16_t
#define RES_TYPE_MAX UINT32_MAX // UINT16_MAX
#define RES_TYPE_JS 1           // res_type_js = 0 => uint16, 1 => uint32

//#define TIMER_DEUG_INFO //ifdef output info about timer values

// ifdef => try to find es repeatly
//#define BENCHMARKMODE
#define BENCHMARKRUNS 20
//#define DEBUG_CONTRACT

//#define BENCHMARKCONTRACT

#ifdef WASM
/**
 * @brief access all entries of a memory buffer to flush the l3-cache. This is not working for all cache-set on all Intel-CPUs (see http://blog.stuffedcow.net/2013/01/ivb-cache-replacement/ for more details).
 * 
 * @param buffer buffer==NULL=> create new buffer, otherwise use buffer with pages as size
 * @param pages size of buffer
 * @param block_size buffer access granularity
 * @return int 
 */
static inline int flush_l3(void *buffer, int pages, int block_size)
{
  int free_buf = 0;
  if (buffer == 0)
  {
    pages = 1024 * 1024 * 4;
    int bufsize = 64 * pages;
    buffer = mmap(NULL, bufsize, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE,
                  -1, 0);
    free_buf = 1;
  }

  int or = 0;
  for (int i = 0; i < pages; i++)
  {
    or |= (int)*((int *)((int)buffer + i * block_size));
  }

  if (free_buf)
    free(buffer);

  return or ;
}
#endif

/**
 * @brief Get the diff between two uint32_t timestamps. Assumes an uint32_t overflow if after <= before
 * 
 * @param before 
 * @param after 
 * @return uint32_t 
 */
static inline uint32_t get_diff(uint32_t before, uint32_t after)
{
  if (after >= before)
  {
    return after - before;
  }
  else if (after + 100 >= before)
  {
    // assume measurment error
    return 0;
  }
  else
  {
    // assume uint32_t overflow
    return after + (UINT32_MAX - before);
  }
}

/**
 * @brief Access Ptr *v
 * 
 * @param v Ptr to address
 * @return int 
 */
#ifdef WASM
__attribute__((optnone))
#endif
static inline int
memaccess(void *v)
{
#ifdef WASM
  int a = *((int *)v);
  return a;
#else
  int rv;
  asm volatile("mov (%1), %0"
               : "+r"(rv)
               : "r"(v)
               :);
  return rv;
#endif
}

#ifdef WASM
/**
 * @brief Waits endless until timer starts counting
 * 
 * @param counts Min counted difference
 */
static inline void warmup(int counts)
{
  if (counts >= UINT32_MAX)
  {
    printf("warmup value to high!");
  }
  uint32_t before = SAB_lib_get_counter_value();
  while (get_diff(before, SAB_lib_get_counter_value()) < counts)
  {
  }
}

/**
 * @brief Get timer value multiple times
 * 
 * @param rounds Number of timer calls
 */
static inline void warmuprounds(int rounds)
{
  while (rounds > 0)
  {
    uint32_t before = SAB_lib_get_counter_value();
    rounds--;
  }
}

/**
 * @brief Waits endless until timer counts as intended
 * 
 */
static inline void warmuptimer()
{
  while (1)
  {
    uint32_t before = SAB_lib_get_counter_value();
    uint32_t after = SAB_lib_get_counter_value();
    if (after - before > 0 && after - before < 100)
    {
      break;
    }
  }
}
#endif


/**
 * @brief Measures access to *v two times and returns the access time difference
 * 
 * @param v Ptr to address
 * @return uint32_t 
 */
static inline uint32_t memaccesstime_abs_double_access(void *v)
{
// add lfence instructions between rdtsc instructions
// rdtscp seems not working as intented (i7-4770)
#ifdef WASM
#ifdef WARMUP
  warmuptimer();
  warmuprounds(10);
#endif

  uint32_t before = SAB_lib_get_counter_value();
  uint32_t a = *((uint32_t *)v);
  uint32_t after1st = SAB_lib_get_counter_value();
  uint32_t b = *((uint32_t *)v);
  uint32_t after2nd = SAB_lib_get_counter_value();

  uint32_t diff1st = get_diff(before, after1st);
  uint32_t diff2nd = get_diff(after1st, after2nd);
  if (diff1st < diff2nd)
  {
    return 0;
  }
  else
  {
    return diff1st - diff2nd;
  }
#else
  printf("memaccesstime_abs_double_access not possible!\n");
  exit(1);
#endif
}

#define TIME_ARR_SIZE 4096
struct timer_info
{
  int time_arr[TIME_ARR_SIZE];
  int time_arr_pos;
  int time_arr_sum;
  uint64_t time_arr_sum_sum;
};
typedef struct timer_info *timer_info_p;

//dummy function used as entry point in wasm code
extern void dummy_for_wat(void);

#ifdef WASM
__attribute__((optnone)) 
/**
 * @brief Non-opt mem access measurment function for gcc
 * 
 * @param v 
 * @return uint32_t 
 */
static inline uint32_t gcc_test_opt(void *v)
{
  uint32_t before = SAB_lib_get_counter_value();
  uint32_t a = *((uint32_t *)v);
  uint32_t after = SAB_lib_get_counter_value();
  //dummy_for_wat();
  return after - before;
}
#endif

// #ifdef WASM
//    __attribute__((optnone))
// #endif
/**
 * @brief Measures mem access time to *v
 * 
 * @param v Ptr to address
 * @param info 
 * @return uint32_t 
 */
static inline uint32_t memaccesstime(void *v, struct timer_info *info)
{

#ifdef WASM
#ifdef WARMUP
  warmuptimer();
  // warmuprounds(10);
#endif

  //this code is not working, even __attribute__((optnone)) is active
  // uint32_t before = SAB_lib_get_counter_value();
  // volatile uint32_t a = *((uint32_t*)v);
  // uint32_t after = SAB_lib_get_counter_value();
  // return get_diff(before,after); //+ a - a;

  //instead: create some artificial dependencies to avoid instruction reordering
  uint32_t a;
  uint32_t after;
  uint32_t before = SAB_lib_get_counter_value();
  //if (before > 0)
  //{
    //before++;
    a = *((uint32_t *)v);
  //}
  if (a == 0)
  {
    after = SAB_lib_get_counter_value();
    after++;
  }
  else
  {
    after = SAB_lib_get_counter_value();
    //if (before > 0)
    //  before--;
  }

  if (a == 0)
  {
    after--;
  }

  uint32_t ret = get_diff(before, after);

  #ifdef TIMER_DEUG_INFO
  info->time_arr[info->time_arr_pos] = ret;
  info->time_arr_sum += ret;
  info->time_arr_pos = (info->time_arr_pos +1) % TIME_ARR_SIZE;
  info->time_arr_sum_sum++;
  if(info->time_arr_pos == 0){
    int mean = info->time_arr_sum/TIME_ARR_SIZE;
    printf("mean timer %i, iterations sum %llu\n", mean,
    info->time_arr_sum_sum); info->time_arr_sum = 0; if(mean < 15){
      int test_sum = 0;
      for(int i=0; i<10000; i++){
      uint32_t before = SAB_lib_get_counter_value();
      uint32_t after = SAB_lib_get_counter_value();
      test_sum += (after-before);
      }
      printf("mean test %i\n", test_sum/10000);
    }
  }
  #endif

  return ret;

#else
  uint32_t rv;
  asm volatile(
      "mfence\n"
      "lfence\n" // serializing operation on all load-from-memory instructions
                 // that were issued prior the LFENCE instruction
      "rdtsc\n"  // get cpu-cycles in EDX(high 32 bit) and EAX(low 32 bit)
      "lfence\n"
      "mov %%eax, %%esi\n" // save EAX(low 32 bit) in ESI
      "mov (%1), %%eax\n"  // EAX = *p;
      "lfence\n"
      "rdtsc\n"             // get cpu-cycles in EDX(high 32 bit) and EAX(low 32 bit)
      "sub %%esi, %%eax\n"  // rv = rdtsc_new.low - rdtsc_old.new
      : "=&a"(rv)           // output
      : "r"(v)              // input
      : "ecx", "edx", "esi" // clobbered register
  );
  return rv;
#endif
}

/**
 * @brief Flushes cache-line corresponding to v
 * 
 * @param v Ptr to address
 */
static inline void clflush(void *v)
{
#ifdef WASM
  printf("clflush not possible!\n");
  exit(1);
#else
  asm volatile("clflush 0(%0)"
               :
               : "r"(v)
               :);
#endif
}

/**
 * @brief Get timestamp as uint32_t. Ifdef WASM => Uses Counter-Thread as timer value (resolution ~2-4ns). Ifndef WASM => Uses rdtscp as timer value (rdtscp timer frequency eqauls the CPU base clock frequency (on Intel CPUs), e.g. i7-4770 3.4GHz or i5-8600K 3.6GHz)
 * 
 * @return uint32_t 
 */
static inline uint32_t rdtscp()
{
#ifdef WASM
  return (uint64_t)SAB_lib_get_counter_value();
#else
  uint32_t rv;
  asm volatile("rdtscp"
               : "=a"(rv)::"edx", "ecx");
  return rv;
#endif
}

/**
 * @brief Get timestamp as uint64_t. For more infos look at rdtscp()
 * 
 * @return uint64_t 
 */
static inline uint64_t rdtscp64()
{

#ifdef WASM
  return (uint64_t)SAB_lib_get_counter_value();
#else
  uint32_t low, high;
  asm volatile("rdtsc"
               : "=a"(low), "=d"(high)::"ecx");
  return (((uint64_t)high) << 32) | low;
#endif
}

/**
 * @brief mefence instruction wrapper
 * 
 */
static inline void mfence() { asm volatile("mfence"); }

// https://wiki.osdev.org/Inline_Assembly
// assembler remarks
//%i are input/ouput operand from c code
// int a=10, b;
// asm ("movl %1, %%eax;
//      movl %%eax, %0;"
//     :"=r"(b)        /* output */
//     :"r"(a)         /* input */
//     :"%eax"         /* clobbered register */
//     );
// so %0 equals b and %1 equals a
// mapping of operands =  'a' refers to EAX, 'b' to EBX,
//'c' to ECX, 'd' to EDX, 'S' to ESI, and 'D' to EDI
// "=" assembly code does not care about the initial value of the mapped
// variable do not need to put output operands to clobbered register possible
// since GCC 3.1
// int current_task;
// asm( "str %[output]"
//   : [output] "=r" (current_task)
//    );

#ifdef WASM
/**
 * @brief Walk through closed ptr-chain until starting ptr is reached again
 * 
 * @param volatile ptr for element in ptr-chain
 * @return void* 
 */
//__attribute__((optnone))
static inline void *walk_through(void *volatile p)
{
  if (p == NULL)
    return 0;

  void *old_p = p;
  //void *q = p;
  //double pointer chasing to avoid BIP eviction policy
  //has no effect
  do
  {
    //q = *((void **)q);
    p = *((void **)p);
  } while (p != old_p);

  return p;
}
#endif

/**
 * @brief Walks through ptr-chain count steps or
 * stopps beforehand if size(chain) < count
 * 
 * @param p 
 * @param count 
 * @return int 
 */
#ifdef WASM
__attribute__((optnone))
#endif
static inline int
walk(void *p, int count)
{
#ifdef WASM
  if (p == NULL)
    return 0;

  int or = 0;
  void *q = p;
  do
  {
    void *old_p = p;
    p = *((void **)p);
    or |= (int)p;
    q = *((void **)q);
    if (q == old_p)
    {
      break;
    }
    count--;
  } while (count > 0);

  return or ;
#else
  // pseudo-code of asm
  // do{
  //  %%rsi = p;
  //  p = *p;
  //  if(p == %%rsi)
  //    break;
  //  count--;
  //} while(count > 0);

  asm volatile(
      "movq %0, %%rsi\n" // Move quadword p to %%rsi
      "1:\n"
      "movq (%0), %0\n"               // Move quadword to *p to p
      "cmpq %0, %%rsi\n"              // Compare quadword p (is now *p) with %%rsi (is now p)
      "jnz 1b\n"                      // Jump to 1b if not zero (*p != p)
      "decl %1\n"                     // decrement count
      "jnz 1b\n"                      // while(count > 0)
      : "+r"(p), "+r"(count)::"rsi"); // define p and count as output and rsi as
                                      // clobbered register
#endif
}

struct cpuidRegs
{
  uint32_t eax;
  uint32_t ebx;
  uint32_t ecx;
  uint32_t edx;
};

struct cpuidCacheInfo
{
  uint32_t type : 5;
  uint32_t level : 3;
  uint32_t selfInitializing : 1;
  uint32_t fullyAssociative : 1;
  uint32_t reserved1 : 4;
  uint32_t logIds : 12;
  uint32_t phyIds : 6;

  uint32_t lineSize : 12;
  uint32_t partitions : 10;
  uint32_t associativity : 10;

  uint32_t sets : 32;

  uint32_t wbinvd : 1;
  uint32_t inclusive : 1;
  uint32_t complexIndex : 1;
  uint32_t reserved2 : 29;
};

union cpuid {
  struct cpuidRegs regs;
  struct cpuidCacheInfo cacheInfo;
};

#ifndef WASM
/**
 * @brief wrapper for cpuid instruction
 * 
 * @param cpuid 
 */
inline void cpuid(union cpuid *c) {
  asm volatile ("cpuid": "+a" (c->regs.eax), "+b" (c->regs.ebx), "+c"
  (c->regs.ecx), "+d" (c->regs.edx));
}
#endif

/**
 * @brief Waits until timer value reached slotend. Retuns 1 if first timer call returns a value greater than slotend and 0 otherwise.
 * 
 * @param slotend Timer value which should be reached
 * @return int 
 */
static inline int slotwait(uint32_t slotend)
{
  if (rdtscp64() > slotend)
    return 1;
  while (rdtscp64() < slotend)
    ;
  return 0;
}

/**
 * @brief Waits cycles cycles. Uses rdtscp64 to get passed cycles.
 * 
 * @param cycles Number of cycles to wait
 * @return int 
 */
static inline int waitcycles(uint64_t cycles)
{
  uint64_t slotend = rdtscp64() + cycles;
  if (rdtscp64() > slotend)
    return 1;
  while (rdtscp64() < slotend)
    ;
  return 0;
}

#endif //__LOW_H__
