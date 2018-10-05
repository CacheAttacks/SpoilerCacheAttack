#include <iostream>
#include <time.h>
#include <unistd.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>		// For uint64_t
#include <stdlib.h>		// For malloc
#include <string.h>
using namespace std;

timespec diff(timespec start, timespec end);

static inline uint64_t rdtscp64() {
  uint32_t low, high;
  asm volatile ("rdtsc": "=a" (low), "=d" (high) :: "ecx");
  return (((uint64_t)high) << 32) | low;
}

int main()
{
    timespec time1, time2;
    int temp;
    uint64_t t1, t2;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time1);
    t1 = rdtscp64();
    for (int i = 0; i< 842000000; i++)
        temp+=temp;
    t2 = rdtscp64();
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time2);
    cout<<diff(time1,time2).tv_sec<<":"<<diff(time1,time2).tv_nsec<<endl;

    uint64_t time_ns = diff(time1,time2).tv_nsec + diff(time1,time2).tv_sec*1000000000;

    cout<< t2-t1 << endl;
    cout << "rdtscp res:" << (t2-t1)/(double)time_ns << endl;
    fgetc(stdin);
    return 0;
}

timespec diff(timespec start, timespec end)
{
    timespec temp;
    if ((end.tv_nsec-start.tv_nsec)<0) {
        temp.tv_sec = end.tv_sec-start.tv_sec-1;
        temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
    } else {
        temp.tv_sec = end.tv_sec-start.tv_sec;
        temp.tv_nsec = end.tv_nsec-start.tv_nsec;
    }
    return temp;
}
