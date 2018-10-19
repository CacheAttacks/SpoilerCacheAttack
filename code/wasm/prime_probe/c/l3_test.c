#include "config.h"
#include <assert.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "low.h"
#include "vlist.h"
#include "probe.h"
#include "timestats.h"
#include "es_management.h"
#include "printf_wrapper.h"
#include "l3.h"
#include "storefor_find_es.h"

/**
 * @brief Access all entries of a list
 * 
 * @param es list of memory-blocks
 */
void access_es(vlist_t es) {
  if (vl_len(es) == 0)
    return;
  for (int i = 0; i < vl_len(es); i++)
    LNEXT(vl_get(es, i)) = vl_get(es, (i + 1) % vl_len(es));
  walk(vl_get(es, 0), vl_len(es));
}

void doStuff(){
  warmuprounds(10000);
  warmuptimer();
}

/**
 * @brief Readjusts timer threshold (difference between cache hit or miss)
 * 
 */
int readjustTimerThreshold(){
  int newTimerThreshold = mem_access_testing(1000000, 0);
  //newTimerThreshold = (newTimerThreshold < 30) ? 30 : newTimerThreshold;
  printf("readjust timer threshold to %i", newTimerThreshold);
  return newTimerThreshold;
}


