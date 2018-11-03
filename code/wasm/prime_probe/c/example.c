#include <inttypes.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "low.h"
#include "vlist.h"
#include "l3.h"
#include "es_management.h"

/**
 * @brief Find some es, select the monitored es and sample the access times via prime-and-probe.
 * 
 * @param app_state_ptr Stores the total program state (es, monitored es, recent measured access times). The intial struct is created by the main function.
 */
void example(void *app_state_ptr){
    //find all es on a i7-4770 (8192 cache-sets)
    //Limit the number of "super es" to 128. Each "super es" is extended to 64 es, therefore we get 128(2^7)*64(2^6) = 8192(2^13) es in total.
    //We do not benchmark anything, therefore parameter 3 and 4 are 0.
    //We use the DEFAULT eviction-set-finding-algorithm.
    build_es_ex(app_state_ptr, 128, 0, 0, DEFAULT);

    //We need to select a subset which is monitored during the prime-and-probe attack.
    //We use the set_monitored_es to select the 6 es from 0 to 5. If you want to monitor e.g. es 1,3,5 use the function set_monitored_es_arr which expects an int array with es indices.
    set_monitored_es(app_state_ptr, 0, 5);

    //Sample each monitored es 10000 times. Do not pause between two samples. Do not send the results to R plumber server. Use wasm-implementation of the prime-and-probe attack.
    //The results are stored in this_app_state->res
    sample_es(app_state_ptr, 10000, 0, 0, 0);
}