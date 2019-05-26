/* src/config.h.  Generated from config.h.in by configure.  */
#define PACKAGE_VERSION "0.02"

#define HAVE_DWARF 1
#define HAVE_LIBDWARF_H 1
/* #undef HAVE_LIBDWARF_LIBDWARF_H */
#define HAVE_BFD_H 1
#define HAVE_SYS_PRCTL_H 1
#define HAVE_SCHED_H 1
#define HAVE_MMAP64 1

#define HAVE_SCHED_SETAFFINITY 1

#define HAVE_SYMBOLS 1

#define WASM


//If a memory access takes less than L3_THRESHOLD units, the algorithm will assume a cache-hit.
//Some example values (be aware that ram clocks and timings are also important):
//35 seems a good value for a i5-5300U with DDR3-1600 (11-11-11-28) (broadwell)
//48 seems a good value for a i7-7500U with DDR3-1866 (14-17-17-40) (kaby-lake)
//36 seems a good value for i7-2600 DDR3-1333 latency unknown (sandy bridge)
//31 seems a good value for i7-4770 DDR3-1600 latency unknown (haswell)
//A general rule: Slow RAM or/and high RAM-timings makes the cache-hit/miss detection easier.
//If you set L3_THRESHOLD <= 0, the algorithm will try to detect a value
//It is advisable to expirment with some values and set a fix value afterwards.
//
//Use the console output to get an appropriate value, e.g. for the i5-5300U with Win 10 v1803 and Google Chrome 74.0.3729.131:
//>>  random access 100000 rounds
//>>  mean:47
//>>  linear access
//>>  mean:23
//>>  threshold: 35
//A value around 35 seems appropriate.
#define L3_THRESHOLD 35

//---------------------------------------------------
//L3 cache parameters
//examples:
// l3-cache i7-4770: 16-way-ass, 8192sets, 4slices =>
// 4(ass)+13(sets)+6(line)=23bits (8MiB) 
// l3-cache i3-5010U: 12-way-ass, 4096sets, 3MiB like 16-way-ass and 4MiB => 4(ass)+12(sets)+6(line)=22bits
//---------------------------------------------------

//Number of the bits for a cache line. Should be always 6 (for all Intel desktop CPUs with the core-architecture).
#define L3_CACHELINE_BITS 6
//Size of a cache line. Equals 2^L3_CACHELINE_BITS_SIZE
#define L3_CACHE_LINE_SIZE 64

//Number of L3-cache slices. Should be equal to the number of physical cores ,e.g. i7-4770(4c/8t) => 4 slices, i5-5300U(2c/4t) => 2 slices
#define L3_CACHE_SLICES 2

//L3-cache associativity. E.g. i7-4770 8MiB L3-Cache 16-way, i5-5300U 3MiB L3-Cache 12-way
//You could use tools like CPU-Z to get your L3-associativity or look up your CPU at cpu-world.com, e.g. http://www.cpu-world.com/CPUs/Core_i7/Intel-Core%20i7-4770.html
#define L3_CACHE_ASSOCIATIVITY 12

//Numer of L3-cache sets. E.g. i7-4770 8MiB L3-Cache 8192sets, i5-5300U 3MiB L3-Cache 4096sets
//Calculate L3_CACHE_SETS: 
//L3_CACHE_SIZE = L3-Cache Size in Bytes
//L3_CACHE_LINE_SIZE = 64
//L3_CACHE_SETS = L3_CACHE_SIZE / L3_CACHE_ASSOCIATIVITY / L3_CACHE_LINE_SIZE
//E.g. i5-5300U 3MiB L3-Cache => 3145728 / 12 / 64 = 4096
#define L3_CACHE_SETS 4096

#ifdef PAGE_SIZE
#undef PAGE_SIZE
#endif
//Number of the bits for the page size. Should be 12 in a typcial desktop env.
#define PAGE_SIZE_BITS 12
//Size of a page. Equals 2^PAGE_SIZE_BITS
#define PAGE_SIZE 4096

// buffer for memoryblocks is a multiple of the L3-cache size
// 2 seems a good value. A higher value will increase the search time but makes it also more likely to find all es.
#define L3_CACHE_SIZE_MULTI 2

//---------------------------------------------------
//Store forward aka colliding addresses configuration
//Please note: A high error rate during the colliding address search makes it only more likely that the subsequent es search will fail. 
//In other words, the influence of a high error rate for the "correctness" of the subsequent es search is negligible. 
//---------------------------------------------------

//Buffer size for the colliding address search in bytes
//E.g. 256MiB = 2^28 => 2^16 pages
//Be aware to adapt the parameter -s TOTAL_MEMORY=512MB accordingly (.vscode/compile.sh)
#define STOREFOR_BUFFER_SIZE 256 * 1024 * 1024

#define STOREFOR_PAGE_COUNT STOREFOR_BUFFER_SIZE / PAGE_SIZE

//Number of validations for a colliding address search.
//A higher value will increase the search time but also lower the error rate.
#define STOREFOR_ROUNDS 50

//Size of the window for the colliding address search. Higher values slow down the search but lower the error rate. 
//64 seems a good value overall, because our tests show that values >64 barely lower the error rate compared to a value of 64.
#define STOREFOR_WINDOW_SIZE 64

//The search will stop if STOREFOR_THRESHOLD_SEARCH_FOR_ES collding addresses are found.
//A higher value will increase the search time but also lower the error rate.
//This should be set with values L3_CACHE_SLICES
#define STOREFOR_THRESHOLD_SEARCH_FOR_ES 115

//If the es search step fails, we will repeat the colliding address search up to STOREFOR_MAX_ITERATIONS times.
#define STOREFOR_MAX_ITERATIONS 10

//Number of store for iterations, e.g. i7-4770 8192 cache-sets / 4 slices / 64 = 2^(13-2-6) = 2^5 = 32
//#define STOREFOR_SEARCHES L3_CACHE_SETS / L3_CACHE_SLICES / L3_CACHE_LINE_SIZE
