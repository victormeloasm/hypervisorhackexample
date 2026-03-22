#include <stdio.h>
#include <stdint.h>

static inline void cpuid(uint32_t leaf, uint32_t *a, uint32_t *b, uint32_t *c, uint32_t *d) {
    __asm__ volatile (
        "cpuid"
        : "=a"(*a), "=b"(*b), "=c"(*c), "=d"(*d)
        : "a"(leaf)
    );
}

int main(void) {
    uint32_t eax, ebx, ecx, edx;
    char vendor[13];

    cpuid(0x40000000, &eax, &ebx, &ecx, &edx);

    ((uint32_t*)vendor)[0] = ebx;
    ((uint32_t*)vendor)[1] = ecx;
    ((uint32_t*)vendor)[2] = edx;
    vendor[12] = '\0';

    printf("Hypervisor CPUID vendor: %s\n", vendor);
    printf("Max leaf: 0x%08x\n", eax);
    return 0;
}
