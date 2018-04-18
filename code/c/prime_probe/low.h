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

#ifndef __LOW_H__
#define __LOW_H__



#define L3_THRESHOLD 140

#ifdef PAGE_SIZE
#undef PAGE_SIZE
#endif
#define PAGE_SIZE 4096


static inline int memaccess(void *v) {
  int rv;
  asm volatile("mov (%1), %0": "+r" (rv): "r" (v):);
  return rv;
}

// static inline uint32_t memaccesstime_old(void *v) {
//   uint32_t rv;
//   asm volatile (
//       "mfence\n"
//       "lfence\n"
//       "rdtsc\n"
//       "mov %%eax, %%esi\n"
//       "mov (%1), %%eax\n"
//       "rdtsc\n"
//       "sub %%esi, %%eax\n"
//       : "=&a" (rv): "r" (v): "ecx", "edx", "esi");   
//   return rv;
// }


//add lfence instructions between rdtsc instructions
//rdtscp seems not working as intented (i7-4770)
static inline uint32_t memaccesstime(void *v) {
  uint32_t rv;
  asm volatile (
      "mfence\n"
      "lfence\n" //serializing operation on all load-from-memory instructions that were issued prior the LFENCE instruction
      "rdtsc\n" //get cpu-cycles in EDX(high 32 bit) and EAX(low 32 bit)
      "lfence\n"
      "mov %%eax, %%esi\n" //save EAX(low 32 bit) in ESI
      "mov (%1), %%eax\n" //EAX = *p;
      "lfence\n"
      "rdtsc\n" //get cpu-cycles in EDX(high 32 bit) and EAX(low 32 bit)
      "sub %%esi, %%eax\n" //rv = rdtsc_new.low - rdtsc_old.new
      : "=&a" (rv) //output
      : "r" (v) //input
      : "ecx", "edx", "esi" //clobbered register
      );   
  return rv;
}

static inline void clflush(void *v) {
#ifdef WASM
  printf("clflush not possible!\n");
  exit(1);
#else
  asm volatile ("clflush 0(%0)": : "r" (v):);
#endif
}

static inline uint32_t rdtscp() {
#ifdef WASM
  printf("rdtscp not possible!\n");
  exit(1);
#else
  uint32_t rv;
  asm volatile ("rdtscp": "=a" (rv) :: "edx", "ecx");
  return rv;
#endif
}

static inline uint64_t rdtscp64() {
#ifdef WASM
  printf("rdtscp not possible!\n");
  exit(1);
#else
  uint32_t low, high;
  asm volatile ("rdtsc": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
#endif
}

static inline void mfence() {
  asm volatile("mfence");
}

//https://wiki.osdev.org/Inline_Assembly
//assembler remarks
//%i are input/ouput operand from c code
//int a=10, b;
//asm ("movl %1, %%eax; 
//      movl %%eax, %0;"
//     :"=r"(b)        /* output */
//     :"r"(a)         /* input */
//     :"%eax"         /* clobbered register */
//     );
// so %0 equals b and %1 equals a
// mapping of operands =  'a' refers to EAX, 'b' to EBX, 
//'c' to ECX, 'd' to EDX, 'S' to ESI, and 'D' to EDI
// "=" assembly code does not care about the initial value of the mapped variable
// do not need to put output operands to clobbered register
// possible since GCC 3.1
//int current_task;
//asm( "str %[output]"
//   : [output] "=r" (current_task)
//    );

//walks through eviction-set count steps or 
//stopps beforehand if size(eviction-set) < count
static inline void walk(void *p, int count) {
  if (p == NULL)
    return;

  //pseudo-code of asm
  //do{
  //  %%rsi = p;
  //  p = *p;
  //  if(p == %%rsi)
  //    break;
  //  count--;
  //} while(count > 0);

  asm volatile(
    "movq %0, %%rsi\n" //Move quadword p to %%rsi
    "1:\n"
    "movq (%0), %0\n" //Move quadword to *p to p
    "cmpq %0, %%rsi\n" //Compare quadword p (is now *p) with %%rsi (is now p) 
    "jnz 1b\n" //Jump to 1b if not zero (*p != p)
    "decl %1\n" //decrement count
    "jnz 1b\n" //while(count > 0)
    : "+r" (p), "+r" (count)::"rsi"); //define p and count as output and rsi as clobbered register
}


struct cpuidRegs {
  uint32_t eax;
  uint32_t ebx;
  uint32_t ecx;
  uint32_t edx;
};

#define CPUID_CACHEINFO		4


#define CACHETYPE_NULL          0
#define CACHETYPE_DATA          1
#define CACHETYPE_INSTRUCTION   2
#define CACHETYPE_UNIFIED       3

struct cpuidCacheInfo {
  uint32_t      type:5;
  uint32_t      level:3;
  uint32_t      selfInitializing:1;
  uint32_t      fullyAssociative:1;
  uint32_t      reserved1:4;
  uint32_t      logIds:12;
  uint32_t      phyIds:6;

  uint32_t      lineSize:12;
  uint32_t      partitions:10;
  uint32_t      associativity:10;

  uint32_t      sets:32;

  uint32_t      wbinvd:1;
  uint32_t      inclusive:1;
  uint32_t      complexIndex:1;
  uint32_t      reserved2:29;
};

union cpuid {
  struct cpuidRegs regs;
  struct cpuidCacheInfo cacheInfo;
};

// inline void cpuid(union cpuid *c) {
//   asm volatile ("cpuid": "+a" (c->regs.eax), "+b" (c->regs.ebx), "+c" (c->regs.ecx), "+d" (c->regs.edx));
// }

static inline int slotwait(uint64_t slotend) {
  if (rdtscp64() > slotend)
    return 1;
  while (rdtscp64() < slotend)
    ;
  return 0;
}



#endif //__LOW_H__
