#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

inline void clflush(volatile void *p){
    asm volatile ("clflush (%0)" :: "r"(p));
}

inline uint64_t rdtscp(){
    unsigned long a, d;
    asm volatile ("rdtscp" : "=a" (a), "=d" (d));
    return a | ((uint64_t)d << 32);
}

int main(int argc, char *argv[]){
    int temp, temp2, i, j, rastgele;
    long long int start, end;
    long long int time;
    int counter = 0;
    int dongu = atoi(argv[1]);
    //printf("%d",dongu);
    int bir=1;
    int iki=2;
	int count = 0;
	int threshold = dongu*900;
//	char *myalloc = malloc(dongu+64);
//	 *myalloc = myalloc+2;
	int val = 0;
	int valold = 0;
	
while(1){
	start = rdtscp();
	for (i=1;i<=dongu;i++){
		clflush(&temp);
		temp2 = temp;
		}
		printf("%lld\n",rdtscp()-start);

} //while close

return 0;
}

