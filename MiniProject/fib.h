#ifndef FIB_H
#define FIB_H

#include <stdint.h>

uint64_t recursive_fib(uint64_t n);
uint64_t dynamic_fib(uint64_t n);
uint64_t matrix_fib(uint64_t n);
void multiply(uint64_t F[2][2], uint64_t M[2][2]);
void power(uint64_t F[2][2], uint64_t n);
void fastdoubling_fib(uint64_t n, uint64_t* a, uint64_t* b);
uint64_t fibonacci_fast_doubling(uint64_t n);

#endif //FIB_H
