#define ROUNDS 100		// For averaging the timings
#define PAGE_COUNT 1024*4
#define PAGE_SIZE 4096

uint32_t measure_read(void *memory);
void storefor_write();

extern uint32_t read_mem_ptr(uint32_t);