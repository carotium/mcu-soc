#include "sleep.h"

void sleep(int cycles) {
    int i;
    for (i=0; i < cycles; i++)
        asm volatile("nop" ::: "memory");
}