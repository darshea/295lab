#include "./version2-master/vectorclass.h"
#include "lab11.h"

double dot_double_vc(double* arr1, double* arr2, uint64_t n) {
    Vec4d accu(0.0);
    for (uint64_t i = 0; i < n; i += 4) {
        Vec4d va = Vec4d().load(arr1 + i);
        Vec4d vb = Vec4d().load(arr2 + i);
        accu += va * vb;
    }
    return horizontal_add(accu);
}

float dot_single_vc(float* arr1, float* arr2, uint64_t n) {
    Vec8f accu(0.0f);
    for (uint64_t i = 0; i < n; i += 8) {
        Vec8f va = Vec8f().load(arr1 + i);
        Vec8f vb = Vec8f().load(arr2 + i);
        accu += va * vb;
    }
    return horizontal_add(accu);
}

void map_poly_double_vc(double* input, double* output, uint64_t length, double a, double b, double c, double d) {
    Vec4d va(a, b, c, d);
    for (uint64_t i = 0; i < length; i += 4) {
        Vec4d vx = Vec4d().load(input + i);
        Vec4d vcubed = vx * vx * vx;
        Vec4d vsquared = vx * vx;
        Vec4d res = va[0] * vcubed + va[1] * vsquared + va[2] * vx + va[3];
        res.store(output + i);
    }
}

void map_poly_single_vc(float* input, float* output, uint64_t length, float a, float b, float c, float d) {
    Vec8f va(a, b, c, d, 0.0f, 0.0f, 0.0f, 0.0f);
    for (uint64_t i = 0; i < length; i += 8) {
        Vec8f vx = Vec8f().load(input + i);
        Vec8f vcubed = vx * vx * vx;
        Vec8f vsquared = vx * vx;
        Vec8f res = va[0] * vcubed + va[1] * vsquared + va[2] * vx + va[3];
        res.store(output + i);
    }
}
