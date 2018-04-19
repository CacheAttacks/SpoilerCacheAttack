#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <emscripten.h>

#define SIZE 2048
#define ARRAYS 100
#define MMAPSIZE 4096

extern int testExternalJSMethod();
extern void shared_array_counter_init();
extern int shared_array_counter_get_value();
extern void shared_array_counter_add_value();
extern void terminate_counter_sub_worker();

      // console.log(exports);
      // console.log(exports._int_sqrt(9));
      
      // var size = 4;
      // var offset = exports._get_mem(size);
      // console.log("offset:" + offset);
      // var i32 = new Uint32Array(Module['wasmMemory'].buffer);
      // for (var i = 0; i < size; i++) {
      //   console.log(i32[i+offset/4]);
      //   i32[i+offset/4] = i;
      // }
      // var value = exports._read_mem(offset);
      // console.log("value:" + value);

      // var my_message = {'wasmMemory' : Module['wasmMemory'], 'offset' : offset};
      // const counter = new Worker('counter_wasm.js');
      // counter.postMessage(my_message);
      // exports._bla();


int *global_buf = 0;

int int_sqrt(int x) {
  return sqrt(x);
}

//simulate page accesses
void arr_access(char **buffer, int size){
  for(int i=0; i<size; i++){
    buffer[i][0] = buffer[i][1] | buffer[i][2];
  }
}

int* get_mem(int size){
  global_buf = (int*)malloc(sizeof(int)*size);
  for(int i=0; i<size;i++)
  {
    global_buf[i] = 42;
  }
  printf("buf add: %#010x\n", (unsigned int)global_buf);
  return global_buf;
}

int read_mem(int *buf){
  printf("offset %#010x\n", (unsigned int)buf);
  printf("buf[0]: %i\n", *buf);
  printf("buf[1]: %i\n", buf[1]);
  return *buf;
}

int test(){
  int a=0;
  for(int i=0; i< 10000; i++){
    a++;
  }
  return a;
}

void bla(int *buf){
  int before = *global_buf;
  test();
  int after = *global_buf;
  int diff = after - before;
  printf("diff %i", diff);
}

void test_javascript_call(){
  int a = 0;
  
  for(int i=0; i< 1000000000; i++)
    a += testExternalJSMethod();

  printf("i %i\n",a);
  printf("finish\n");
}

void init_counter(){
  int x = EM_ASM_INT({
  Module.print('I received: ' + $0);
  var a = 1001;
  return $0 + 1;
  }, 100);
  printf("%i\n", x);
}

void get_counter(){
  int a = EM_ASM_INT(
    return a;
  );
  printf("a is %i\n",a);
}

int main(int argc, char ** argv) {
  printf("start c code\n");

  int *value = (int*)malloc(sizeof(int)*10);
  int a = 0;
  for(int i=0; i<10;i++)
  {
    value[i] = shared_array_counter_get_value();
    // for(int b=0; b<1000; b++)
    //  a+=3;
  }
  for(int i=0; i<10;i++)
  {
    printf("value:%i\n",value[i]);
  }
  printf("%i\n",a);

  terminate_counter_sub_worker();

  //int *arr = calloc(SIZE, sizeof(int));
  //int *arr2 = calloc(4096, sizeof(int));
  // printf("ŝqrt(3): %i\n", int_sqrt(3));  

  // for(int i=0; i<SIZE; i+=1024)
  // {
  //   printf("arr+%i: %p\n", i, arr+i);
  // }

  //printf("arr: %p\n", arr);  
  //printf("arr: %p\n", arr2);

  // emscripten_run_script("alert('hi')");
  // while(global_buf == 0 || *global_buf == 42){}

  // printf("*global_buf != 42");

  // char **buffers = calloc(sizeof(void*), ARRAYS);
  // for(int i=0; i<ARRAYS; i++){
  //   buffers[i] = mmap(NULL, MMAPSIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
  // }
  

  // while(1){
  //  arr_access(buffers, ARRAYS);
  //  sleep(1);
  // }

  // char *buffer = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
  // printf("buffer: %p\n", buffer); 
  // while(1){
  //   buffer[1] |= buffer[2];
  // }
}

//http://webassembly.org/docs/semantics/#linear-memory
//A linear memory can be considered to be an untyped array of bytes, and it is unspecified how embedders map this array into their process’ own virtual memory.