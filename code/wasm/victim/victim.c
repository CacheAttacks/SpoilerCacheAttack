#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include "SABcounter.h"

#define SIZE 2048
#define ARRAYS 100
#define MMAPSIZE 4096

#define TABLESIZE 4096

int int_sqrt(int x) {
  return sqrt(x);
}

//simulate page accesses
void arr_access(char **buffer, int size){
  for(int i=0; i<size; i++){
    buffer[i][0] = buffer[i][1] | buffer[i][2];
  }
}

int main(int argc, char ** argv) {
  printf("start c code\n");

  char *buffer = calloc(sizeof(int*), TABLESIZE);
  int access_indices = {10,95,1024,1234,2083};
  int number_of_access_indices = 5;

  while(1){
    for(int i=0; i<number_of_access_indices; i++)
    {
      buffer[access_indices] = buffer[access_indices] + 2;
    }
  }

  //SAB_bench_call_methods();

  SAB_terminate_counter_sub_worker();
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