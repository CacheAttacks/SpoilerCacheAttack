#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <inttypes.h>

#define SIZE 2048
#define ARRAYS 100
#define MMAPSIZE 4096

#define TABLESIZE 4096
#define NUMBER_OF_ACCESESS 5

//simulate page accesses
void arr_access(char **buffer, int size){
  for(int i=0; i<size; i++){
    buffer[i][0] = buffer[i][1] | buffer[i][2];
  }
}

static inline uint64_t rdtscp64() {
  uint32_t low, high;
  asm volatile ("rdtscp": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

int flush_l3(int page_offset){
  int pages = 1024;
  int page_size = 4096;
  int bufsize = pages * page_size;
  void* buffer = mmap(NULL, bufsize, PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE, -1, 0);

  int or = 0;
  int flip = 0;
  char bitstr[] = "1000111001";
  while(1){
    uint64_t before = rdtscp64();
    for(int a=0; a<strlen(bitstr); a++){
      if(bitstr[a] == '1') {
        for(int i=0; i<pages; i++){
          or |= *((int*)((uintptr_t)buffer + i * page_size + page_offset));
          //or |= *((int*)((uintptr_t)buffer + i * page_size));
        }
      }
      //if(flip % 5 == 0 || flip % 5 == 1)
      for(int i=0;i<20000;i++){
        or += 1;
      }
      //flip++;
    }
    for(int i=0;i<50000;i++){
        or += 1;
    }
    uint64_t after = rdtscp64();
    //printf("cycles: %" PRId64 "\n", after-before);
  }

  return or;
}

void test(){
  int *buffer = (int*)calloc(sizeof(int*), TABLESIZE);
  int access_indices[NUMBER_OF_ACCESESS] = {10,95,1024,1234,2083};
  int sleeptime = 10000;

  while(1){
    for(int i=0; i<NUMBER_OF_ACCESESS; i++)
    {
      buffer[access_indices[i]] = buffer[access_indices[i]] + 2;
      usleep(sleeptime);
    }
  }
}

int main(int argc, char ** argv) {
  flush_l3(2048);
}

//http://webassembly.org/docs/semantics/#linear-memory
//A linear memory can be considered to be an untyped array of bytes, and it is unspecified how embedders map this array into their process’ own virtual memory.

// void test(){
//   int *arr = calloc(SIZE, sizeof(int));
//   int *arr2 = calloc(4096, sizeof(int));
//   printf("ŝqrt(3): %i\n", int_sqrt(3));  

//   for(int i=0; i<SIZE; i+=1024)
//   {
//     printf("arr+%i: %p\n", i, arr+i);
//   }

//   printf("arr: %p\n", arr);  
//   printf("arr: %p\n", arr2);

//   emscripten_run_script("alert('hi')");
//   while(global_buf == 0 || *global_buf == 42){}

//   printf("*global_buf != 42");

//   char **buffers = calloc(sizeof(void*), ARRAYS);
//   for(int i=0; i<ARRAYS; i++){
//     buffers[i] = mmap(NULL, MMAPSIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
//   }
  

//   while(1){
//    arr_access(buffers, ARRAYS);
//    sleep(1);
//   }

//   char *buffer = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
//   printf("buffer: %p\n", buffer); 
//   while(1){
//     buffer[1] |= buffer[2];
//   }
// }