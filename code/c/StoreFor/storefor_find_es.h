#define ROUNDS 100		// For averaging the timings
#define PAGE_COUNT 1024*4
#define PAGE_SIZE 4096

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

uint32_t measure_read(void *memory);
void storefor_write();

