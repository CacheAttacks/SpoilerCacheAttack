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
#include <assert.h>

#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "es_management.h"

#define SIZE 2048
#define ARRAYS 100
#define MMAPSIZE 4096

#define TABLESIZE 4096
#define NUMBER_OF_ACCESESS 5

#define NOISY_CHANNEL_OFFSET_SEND_START 0
#define NOISY_CHANNEL_OFFSET_SEND_END 31
#define NOISY_CHANNEL_OFFSET_REC_START 34
#define NOISY_CHANNEL_OFFSET_REC_END 63
#define COMMUNICATION_CHANNEL_OFFSET_START 32
#define COMMUNICATION_CHANNEL_OFFSET_END 32

//simulate page accesses
void arr_access(char **buffer, int size){
  for(int i=0; i<size; i++){
    buffer[i][0] = buffer[i][1] | buffer[i][2];
  }
}

int sendbitstr(void* buffer, char *bitstr, int pages, int page_size, int page_offset, int (*waitop)(uint64_t), uint64_t waittime, int length_on) {
  int or = 0;
  for(int a=0; a<strlen(bitstr); a++){
    if(bitstr[a] == '1') {
      for(int a=0; a<length_on; a++){
        for(int i=0; i<pages; i++){
          or |= *((int*)((uintptr_t)buffer + i * page_size + page_offset));
        }
      }
    }
    //if(flip % 5 == 0 || flip % 5 == 1)
    // for(int i=0;i<20000;i++){
    //   or += 1;
    // }
    //flip++;
    (*waitop)(waittime);
  }
  return or;
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
    // for(int i=0; i<pages; i++){
    //     or |= *((int*)((uintptr_t)buffer + i * page_size + page_offset));
    // }
    //waitcycles(200000);
    sendbitstr(buffer, bitstr, pages, page_size, page_offset, &waitcycles, 100000, 1);
    usleep(300);
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

void print_bit_covert_channel(void (*probe_operation)(void*), void** cacheset_head_arr, 
int cacheset_index_min, int cacheset_index_max, int repeat_probe){
  for(int i=0; i<=repeat_probe; i++) {
    for(int cacheset_index=cacheset_index_min; cacheset_index<=cacheset_index_max; cacheset_index++){
      (*probe_operation)(cacheset_head_arr[cacheset_index]);
    }
  }    
}

void print_bitstr_covert_channel(char *bitstr, void (*probe_operation)(void*), 
void** cacheset_head_arr, int cacheset_index_min, int cacheset_index_max, int repeat_probe, int snyc_repeat, 
int (*waitop)(uint64_t), uint64_t wait_units){
  for(int a=0; a<strlen(bitstr); a++){
    if(a % 10 == 0){
      print_bit_covert_channel(probe_operation, cacheset_head_arr, cacheset_index_min, cacheset_index_max, 
      snyc_repeat);
      (*waitop)(wait_units);
    }
    if(bitstr[a] == '1') {
      print_bit_covert_channel(probe_operation, cacheset_head_arr, cacheset_index_min, cacheset_index_max, 
      repeat_probe);
    }
    (*waitop)(wait_units);
  }
}

int main(int argc, char ** argv) {
  struct app_state* this_app_state = (struct app_state*)calloc(sizeof(struct app_state),1);
  this_app_state->l3_threshold = 140;

  build_es((void*)this_app_state, 1);

  set_monitored_es((void*)this_app_state, 0, 0);

  sample_es((void*)this_app_state, 1, 0);

  printf("probe %i es:\n", this_app_state->l3->nmonitored);

  //measure idle noise to check wether listener is connected to channel
  set_monitored_es((void*)this_app_state, 32, 63);
  double idle_noise_mean = mesure_mean_access_time(this_app_state, 2000);
  printf("idle_noise_mean %f\n", idle_noise_mean);

  // while(1){
  //   l3_probe(this_app_state->l3, this_app_state->res);
  // }

  //800cycles resolution
  // pause 5 steps ~ 4000 cycles
  //repeat 4 should min 2 steps high
  //reapeat sync 30 min 10 steps high

  char* command = calloc(sizeof(char), 128);
  int wait_cycles = 4000;
  int repeat_probe = 4;
  int sync_repeat = 30;
  while(1){
    printf("enter command e.g. w 10 , s 12:213 , c 100000 , r 3 , n 10 , y 2000, p 10, b \n");
    fgets(command, 128, stdin);
    //-------------------------------------------PRINT BITSTR-------------------------------------------
    if(command[0] == 'w'){
      int wait_time_sec = atoi(command+2);
      printf("wait %i sec\n", wait_time_sec);
      char bitstr[] = "1000111001";
      uint64_t start = get_time_in_ms();
      while(get_time_in_ms() - start < wait_time_sec*1000){
        print_bitstr_covert_channel(bitstr, &probe_only, this_app_state->l3->monitoredhead, 0, 5, repeat_probe, sync_repeat,
          &waitcycles, wait_cycles);
      }
    } 
    //---------------------------------------PRINT ON CHANNEL--------------------------------------------
    else if (command[0] == 'p'){
      char bitstr[] = "1000111001";
      int wait_time_sec = atoi(command+2);
      uint64_t before = get_time_in_ms(), before_print, after_print;
      while(get_time_in_ms() - before < 1000 * wait_time_sec){
        before_print = rdtscp64();
        print_bitstr_covert_channel(bitstr, &probe_only, this_app_state->l3->monitoredhead, COMMUNICATION_CHANNEL_OFFSET_START, COMMUNICATION_CHANNEL_OFFSET_END, repeat_probe, sync_repeat, &waitcycles, wait_cycles);
        after_print = rdtscp64();
      }
      printf("last print bitstr time %" PRIu64 "\n", after_print - before_print);
    }
    //-------------------------------------------NOISE-----------------------------------------------
    else if(command[0] == 'n'){
      int wait_time_sec = atoi(command+2);
      printf("noise new %i sec\n", wait_time_sec);
      uint64_t start = get_time_in_ms();
      while(get_time_in_ms() - start < wait_time_sec*1000){
        for(int i=0; i<100; i++){
          print_bit_covert_channel(&probe_only, this_app_state->l3->monitoredhead, 0, 31, repeat_probe);
        }
      }
    }
    //-------------------------------------------OPEN CHANNEL-------------------------------------------
    else if(command[0] == 'o'){
      int wait_time_sec = atoi(command+2);
      printf("open channel, break after %i sec\n", wait_time_sec);
      uint64_t start = get_time_in_ms(), sec_switch = get_time_in_ms();
      int send_noise = 0;
      while(get_time_in_ms() - start < wait_time_sec*1000){
        if(send_noise % 2 == 0){
          for(int i=0; i<100; i++){
            print_bit_covert_channel(&probe_only, this_app_state->l3->monitoredhead, NOISY_CHANNEL_OFFSET_SEND_START, NOISY_CHANNEL_OFFSET_SEND_END, repeat_probe);
          }
        } else {
          double access_time = mesure_mean_access_time(this_app_state, 2000);
          //printf("access_time %f, idle_noise_mean %f\n", access_time, idle_noise_mean);
          if(access_time > 2 * idle_noise_mean){
            printf("access_time %f, idle_noise_mean %f\n", access_time, idle_noise_mean);
            printf("listener seems connected!\n");
            break;
          }
        }
        if(get_time_in_ms() - sec_switch > 1000){
          sec_switch = get_time_in_ms();
          send_noise++;
          if(send_noise % 2 == 0){
            set_monitored_es((void*)this_app_state, 0, 0);
          } else {
            set_monitored_es((void*)this_app_state, NOISY_CHANNEL_OFFSET_REC_START, NOISY_CHANNEL_OFFSET_REC_END);
          }
        }
      }
      //reset monitored es for further data sending
      //dats sending use l3->monitorhead
      set_monitored_es((void*)this_app_state, 0, 0);
    }
    //---------------------------------------BENCHMARK--------------------------------------------
    else if (command[0] == 'b'){
      int it = atoi(command+2);
      uint64_t before = get_time_in_ms(), before_print, after_print;
      while(get_time_in_ms() - before < 200){
        before_print = rdtscp64();
        for(int i = 0; i<it; i++)
          probe_only(this_app_state->l3->monitoredhead[COMMUNICATION_CHANNEL_OFFSET_START]); 
        after_print = rdtscp64();
      }
      printf("cycles prime single cache set: %" PRIu64 "\n", after_print - before_print);
    }
    //-------------------------------------------SELECT ES-----------------------------------------------
    else if (command[0] == 's'){
      for(int i=0; i<128 && command[i] != '\n'; i++){
        if(command[i] == ':'){
          command[i] = '\0';
          int min_index = atoi(command+2);
          int max_index = atoi(command+i+1);
          printf("selected es from %i to %i\n", min_index, max_index);
          set_monitored_es((void*)this_app_state, min_index, max_index);
        }
      }
    }
    //-------------------------------------------SET WAIT CYCLES-----------------------------------------------
    else if (command[0] == 'c'){
      wait_cycles = atoi(command+2);
    } 
    //-------------------------------------------SET REPEAT CYCLES-----------------------------------------------
    else if (command[0] == 'r'){
      repeat_probe = atoi(command+2);
    }
    //-------------------------------------------SET REPEAT CYCLES-----------------------------------------------
    else if (command[0] == 'y'){
      sync_repeat = atoi(command+2);
    }
  }

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