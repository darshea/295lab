#define _POSIX_C_SOURCE 199309L
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "fib.h"

// Assuming these are declared in fib.h
uint64_t recursive_fib(uint64_t n);
uint64_t dynamic_fib(uint64_t n);
uint64_t matrix_fib(uint64_t n);
uint64_t fibonacci_fast_doubling(uint64_t n);

#define TIMING_RESULT(DESCR, CODE) do { \
    struct timespec start, end; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start); \
    CODE; \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end); \
    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9; \
    printf("%25s took %10.6f ms\n", DESCR, elapsed * 1000); \
} while(0)

void time_fib(const char* descr, uint64_t fib_func(uint64_t), uint64_t n) {
    TIMING_RESULT(descr, fib_func(n));
}

int main(void) {
    uint64_t n = 1000000;
    
    // Warmup
    //time_fib("warmup", recursive_fib, n);
    time_fib("warmup", dynamic_fib, n);
    
    // Timing
    //time_fib("recursive_fib", recursive_fib, n);
    //time_fib("dynamic_fib", dynamic_fib, n);
    time_fib("matrix_fib", matrix_fib, n);
    time_fib("fast_doubling_fib", fibonacci_fast_doubling, n);
    
    return 0;
}