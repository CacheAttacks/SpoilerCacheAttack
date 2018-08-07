#define HIT_THRESHOLD 80

#define pipeline_flush() asm volatile("mov $0, %%eax\n\tcpuid\n\tlfence" :/*out*/ : /*in*/ : "rax","rbx","rcx","rdx","memory")
#define clflush(addr) asm volatile("clflush (%0)"::"r"(addr):"memory")

#define HIT_LIMIT 30

#define TIMEY_LINE_AREA_OFFSET 0x1000

#define VALUES 256

