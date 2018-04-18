#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

//#include <util.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"

#define SAMPLES 1000
#define LNEXT(t) (*(void **)(t))

int main(int ac, char **av) {
  // int i=3,a=4;
  // int *ip = &i;
  // int **ipp = &ip;
  // printf("ip:%p, ipp:%p, LNEXT(ipp):%p\n", ip, ipp, LNEXT(ipp));


  // vlist_t list = vl_new();
  // vl_push(list, ip);
  // vl_push(list, &a);
  // printf("LNEXT(list):%p\n",LNEXT(list));
  // printf("LNEXT(list):%p\n",vl_get(list,0));

  // exit(1);
  
  //delayloop(3000000000U);

  //l3-cache i7-4770: 16-way-ass, 8192sets => 4+13+6=23bits (8MiB)

  l3pp_t l3 = l3_prepare(NULL);

  
  int nsets = l3_getSets(l3);
  int nmonitored = nsets/64;
  printf("nmonitored:%i\n",nmonitored);

  for (int i = 17; i < nsets; i += 64)
    l3_monitor(l3, i);

  uint16_t *res = calloc(SAMPLES * nmonitored, sizeof(uint16_t));
  for (int i = 0; i < SAMPLES * nmonitored; i+= 4096/sizeof(uint16_t))
    res[i] = 1;

  l3_repeatedprobe(l3, SAMPLES, res, 0);

  printf("size of eviction sets\n");
  for(int i = 0; i < nmonitored; i++){
    vlist_t list = l3->groups[l3->monitoredset[i] / l3->groupsize];
    printf("%d ", list->len);
  }
  printf("\nnumber of accesses with access_time > L3_THRESHOLD in each evictionset\n");
  printf("x-axis eviction-sets, y-axis sample\n");

  for (int i = 0; i < SAMPLES; i++) {
    for (int j = 0; j < nmonitored; j++) {
      printf("%d ", res[i*nmonitored + j]);
    }
    if(nmonitored > 0)
      putchar('\n');
  }

  free(res);
  l3_release(l3);
}
