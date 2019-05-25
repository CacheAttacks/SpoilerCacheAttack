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

//---------------------------------------------------
//L3 cache parameters
//examples:
// l3-cache i7-4770: 16-way-ass, 8192sets, 4slices =>
// 4(ass)+13(sets)+6(line)=23bits (8MiB) 
// l3-cache i3-5010U: 12-way-ass, 4096sets, 3MiB like 16-way-ass and 4MiB => 4(ass)+12(sets)+6(line)=22bits
//---------------------------------------------------

//Number of the bits for a cache line. Should be always 6 (for all Intel desktop CPUs with the core-architecture).
#define L3_CACHELINE_BITS_SIZE 6
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

//---------------------------------------------------
//Store forward aka colliding addresses configuration
//Please note: A high error rate during the colliding address search makes it only more likely that the subsequent es search will fail. 
//In other words, the influence of a high error rate for the "correctness" of the subsequent es search is negligible. 
//---------------------------------------------------

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
