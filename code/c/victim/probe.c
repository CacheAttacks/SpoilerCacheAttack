#include "config.h"
#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <strings.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <inttypes.h>

#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "timestats.h"

extern int L3_THRESHOLD;

#define BPROBEPTR(p) (OFFSET((p), sizeof(void *)))
#define PROBE_PTR_OFFSET2(p) (OFFSET((p), 2*sizeof(void *)))
#define PROBE_PTR_OFFSET4(p) (OFFSET((p), 4*sizeof(void *)))
#define PROBE_PTR_OFFSET6(p) (OFFSET((p), 6*sizeof(void *)))
#define PROBE_PTR_OFFSET8(p) (OFFSET((p), 8*sizeof(void *)))
#define PROBE_PTR_OFFSET10(p) (OFFSET((p), 10*sizeof(void *)))
#define PROBE_PTR_OFFSET12(p) (OFFSET((p), 12*sizeof(void *)))
#define PROBE_PTR_OFFSET14(p) (OFFSET((p), 14*sizeof(void *)))

//Cache-Line has only 64 use this only if there is no bprobe necessary
#define PROBE_PTR_OFFSET1(p) (OFFSET((p), 1*sizeof(void *)))
#define PROBE_PTR_OFFSET3(p) (OFFSET((p), 3*sizeof(void *)))
#define PROBE_PTR_OFFSET5(p) (OFFSET((p), 5*sizeof(void *)))
#define PROBE_PTR_OFFSET7(p) (OFFSET((p), 7*sizeof(void *)))
#define PROBE_PTR_OFFSET9(p) (OFFSET((p), 9*sizeof(void *)))
#define PROBE_PTR_OFFSET11(p) (OFFSET((p), 11*sizeof(void *)))
#define PROBE_PTR_OFFSET13(p) (OFFSET((p), 13*sizeof(void *)))
#define PROBE_PTR_OFFSET15(p) (OFFSET((p), 15*sizeof(void *)))

//cycles through all memory-blocks in a eviction-set
//return sum time for all accesses
int probetime(void *pp) {
  if (pp == NULL)
    return 0;
  int rv = 0;
  void *p = (void *)pp;
  uint32_t s = rdtscp();
  do {
    p = LNEXT(p);
  } while (p != (void *) pp);
  return rdtscp()-s;
}

int probetime_adv_1(void *pp) {
  if (pp == NULL)
    return 0;
    //void *p = (void *)pp;  
    uint32_t s = rdtscp();
    for(int i=0; i<1; i++){
      pp = LNEXT(pp);
    }
    return rdtscp()-s;
}

int probetime_adv_2(void *pp) {
  if (pp == NULL)
    return 0;
    //void *p = (void *)pp;  
    pp = PROBE_PTR_OFFSET2((void *)pp);
    uint32_t s = rdtscp();
    for(int i=0; i<2; i++){
      pp = LNEXT(pp);
    }
    return rdtscp()-s;
}

int probetime_adv_4(void *pp) {
  if (pp == NULL)
    return 0;
    pp = PROBE_PTR_OFFSET4((void *)pp); 
    //void *p = (void *)pp;  
    uint32_t s = rdtscp();
    for(int i=0; i<4; i++){
      pp = LNEXT(pp);
    }
    return rdtscp()-s;
}

int probetime_adv_8(void *pp) {
  if (pp == NULL)
    return 0;
    //void *p = (void *)pp;  
    pp = PROBE_PTR_OFFSET8((void *)pp);
    uint32_t s = rdtscp();
    for(int i=0; i<8; i++){
      pp = LNEXT(pp);
    }
    return rdtscp()-s;
}

int probetime_adv_16(void *pp) {
  if (pp == NULL)
    return 0;
    //void *p = (void *)pp;  
    uint32_t s = rdtscp();
    for(int i=0; i<16; i++){
      pp = LNEXT(pp);
    }
    return rdtscp()-s;
}

int probetime_split_2(void *pp) {
  if (pp == NULL)
    return 0;
  //void *p = (void *)pp;  
  void *bp = NEXTPTR((void *)pp);  
  uint32_t s = rdtscp();
  for(int i=0; i<8; i++){
    pp = LNEXT(pp);
    bp = LNEXT(bp);
  }
  return rdtscp()-s;
}

int probetime_split_4(void *pp) {
  if (pp == NULL)
    return 0;
  //void *p = (void *)pp;  
  void *b_off_4 = PROBE_PTR_OFFSET4((void *)pp);  
  void *b_off_8 = PROBE_PTR_OFFSET8((void *)pp);
  void *b_off_12 = PROBE_PTR_OFFSET12((void *)pp);
  uint32_t s = rdtscp();
  for(int i=0; i<4; i++){
    pp = LNEXT(pp);
    b_off_4 = LNEXT(b_off_4);
    b_off_8 = LNEXT(b_off_8);
    b_off_12 = LNEXT(b_off_12);
  }
  return rdtscp()-s;
}

int probetime_split_8(void *pp) {
  if (pp == NULL)
    return 0;
  //void *p = (void *)pp;  
  void *b_off_2 = PROBE_PTR_OFFSET2((void *)pp);  
  void *b_off_4 = PROBE_PTR_OFFSET4((void *)pp);
  void *b_off_6 = PROBE_PTR_OFFSET6((void *)pp);
  void *b_off_8 = PROBE_PTR_OFFSET8((void *)pp);  
  void *b_off_10 = PROBE_PTR_OFFSET10((void *)pp);
  void *b_off_12 = PROBE_PTR_OFFSET12((void *)pp);
  void *b_off_14 = PROBE_PTR_OFFSET14((void *)pp);
  uint32_t s = rdtscp();
  for(int i=0; i<2; i++){
    pp = LNEXT(pp);
    b_off_2 = LNEXT(b_off_2);
    b_off_4 = LNEXT(b_off_4);
    b_off_6 = LNEXT(b_off_6);
    b_off_8 = LNEXT(b_off_8);
    b_off_10 = LNEXT(b_off_10);
    b_off_12 = LNEXT(b_off_12);
    b_off_14 = LNEXT(b_off_14);
  }
  return rdtscp()-s;
}

p_probetime get_probetime_by_type(int type){
  if(type == 0)
    return &probetime; 
  else if(type == 22)
    return &probetime_split_2; 
  else if(type == 24)
    return &probetime_split_4; 
  else if(type == 28)
    return &probetime_split_4; 
  else if(type == 11)
    return &probetime_adv_1; 
  else if(type == 12)
    return &probetime_adv_2; 
  else if(type == 14)
    return &probetime_adv_4; 
  else if(type == 18)
    return &probetime_adv_8; 
  else if(type == 116)
    return &probetime_adv_8; 
  printf("type unknown!\n");
    return 0;
}

//cycles through all memory-blocks in a eviction-set
//access them and count accesses with (accesstime > L3_THRESHOLD)
int probecount(void *pp) {
  if (pp == NULL)
    return 0;
  int rv = 0;
  void *p = (void *)pp;
  //cycle through all memory-blocks in the eviction-set once
  //remember LNEXT(p) point to memory-block[i+1]
  do {
    //uint32_t s = memaccesstime(p, info);
    uint32_t s = rdtscp();
    p = LNEXT(p);
    s = rdtscp() - s;
    if (s > L3_THRESHOLD)
      rv++;
  } while (p != (void *) pp);
  return rv;
}

int bprobecount(void *pp) {
  if (pp == NULL)
    return 0;
  //remember memory_block[i].add + offset + 1 points to memory_block[i-1]
  return probecount(NEXTPTR(pp));
}

int bprobetime(void *pp, p_probetime func_ptr) {
  if (pp == NULL)
    return 0;
  return (*func_ptr)(NEXTPTR(pp));
}

void probe_only(void *pp) {
  if (pp == NULL)
    return;
  void *p = (void *)pp;
  do {
    p = LNEXT(p);
  } while (p != (void *) pp);
}

//#define NUMBER_OF_PROBE_ADD 1
void probe_only_adv_1(void *pp) {
  if (pp == NULL)
    return;
    //void *p = (void *)pp;  
    for(int i=0; i<1; i++){
      pp = LNEXT(pp);
    }
}

void probe_only_adv_2(void *pp) {
  if (pp == NULL)
    return;
    //void *p = (void *)pp;  
    for(int i=0; i<2; i++){
      pp = LNEXT(pp);
    }
}

void probe_only_adv_4(void *pp) {
  if (pp == NULL)
    return;
    //void *p = (void *)pp;  
    for(int i=0; i<4; i++){
      pp = LNEXT(pp);
    }
}

void probe_only_adv_8(void *pp) {
  if (pp == NULL)
    return;
    //void *p = (void *)pp;  
    for(int i=0; i<8; i++){
      pp = LNEXT(pp);
    }
}

void probe_only_split_2(void *pp) {
  if (pp == NULL)
    return;
  //void *p = (void *)pp;  
  void *bp = NEXTPTR((void *)pp);  

  for(int i=0; i<8; i++){
    pp = LNEXT(pp);
    bp = LNEXT(bp);
  }
}

void* get_probe_only_by_type(int type){
  if(type == 0)
    return &probe_only; 
  else if(type == 3)
    return &probe_only_split_2; 
  else if(type == 1)
    return &probe_only_adv_1; 
  else if(type == 2)
    return &probe_only_adv_2; 
  else if(type == 4)
    return &probe_only_adv_4; 
  else if(type == 8)
    return &probe_only_adv_8; 
  printf("type unknown!\n");
    return 0;
}