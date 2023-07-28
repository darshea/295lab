#include "./version2-master/vectorclass.h"

void dot_double_vc(double* a, double* b, int n, double* result) {
    Vec4d accu(0.0);
    for (int i = 0; i < n; i += 4) {
        Vec4d va = Vec4d().load(a + i);
        Vec4d vb = Vec4d().load(b + i);
        accu += va * vb;
    }
    *result = horizontal_add(accu);
}

void dot_single_vc(float* a, float* b, int n, float* result) {
    Vec8f accu(0.0f);
    for (int i = 0; i < n; i += 8) {
        Vec8f va = Vec8f().load(a + i);
        Vec8f vb = Vec8f().load(b + i);
        accu += va * vb;
    }
    *result = horizontal_add(accu);
}

void map_poly_double_vc(double* a, double* x, int n, double* result) {
    Vec4d va = Vec4d().load(a);
    for (int i = 0; i < n; i += 4) {
        Vec4d vx = Vec4d().load(x + i);
        Vec4d vcubed = vx * vx * vx;
        Vec4d vsquared = vx * vx;
        Vec4d res = va[0] * vcubed + va[1] * vsquared + va[2] * vx + va[3];
        res.store(result + i);
    }
}

void map_poly_single_vc(float* a, float* x, int n, float* result) {
    Vec8f va = Vec8f().load(a);
    for (int i = 0; i < n; i += 8) {
        Vec8f vx = Vec8f().load(x + i);
        Vec8f vcubed = vx * vx * vx;
        Vec8f vsquared = vx * vx;
        Vec8f res = va[0] * vcubed + va[1] * vsquared + va[2] * vx + va[3];
        res.store(result + i);
    }
}
