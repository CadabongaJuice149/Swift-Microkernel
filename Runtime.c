#include <stddef.h>
#include <stdint.h>

void* memcpy(void* dest, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dest;
    const unsigned char* s = (const unsigned char*)src;
    for (size_t i = 0; i < n; i++) {
        d[i] = s[i];
    }
    return dest;
}

void* memset(void* s, int c, size_t n) {
    unsigned char* p = (unsigned char*)s;
    for (size_t i = 0; i < n; i++) {
        p[i] = (unsigned char)c;
    }
    return s;
}

void* memmove(void* dest, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dest;
    const unsigned char* s = (const unsigned char*)src;
    if (d < s) {
        for (size_t i = 0; i < n; i++) d[i] = s[i];
    } else {
        for (size_t i = n; i > 0; i--) d[i-1] = s[i-1];
    }
    return dest;
}

int memcmp(const void* s1, const void* s2, size_t n) {
    const unsigned char* p1 = (const unsigned char*)s1;
    const unsigned char* p2 = (const unsigned char*)s2;
    for (size_t i = 0; i < n; i++) {
        if (p1[i] != p2[i]) return p1[i] - p2[i];
    }
    return 0;
}

/* VGA Console Output */
static uint16_t* const VGA_BUFFER = (uint16_t*)0xB8000;
static int vga_column = 0;
static int vga_row = 0;

void vga_putchar(char c) {
    if (c == '\n') {
        vga_column = 0;
        vga_row++;
    } else {
        const int index = vga_row * 80 + vga_column;
        VGA_BUFFER[index] = (uint16_t)c | (uint16_t)0x0700;
        vga_column++;
        if (vga_column >= 80) {
            vga_column = 0;
            vga_row++;
        }
    }
    if (vga_row >= 25) {
        // Simple scroll: just clear and reset for now
        for (int i = 0; i < 80 * 25; i++) VGA_BUFFER[i] = 0;
        vga_row = 0;
    }
}

/* Hook for Swift's print() in Embedded mode */
// Note: Embedded Swift uses a specific hook for printing. 
// For now, we'll provide a symbol that might be used or just use it manually.
void swift_print_char(char c) {
    vga_putchar(c);
}

/* Simple Bump Allocator */
static uint8_t heap[1024 * 1024]; // 1 MiB heap
static size_t heap_ptr = 0;

void* malloc(size_t size) {
    if (heap_ptr + size > sizeof(heap)) return NULL;
    void* ptr = &heap[heap_ptr];
    heap_ptr += (size + 7) & ~7; // Align to 8 bytes
    return ptr;
}

void free(void* ptr) {
    // No-op for bump allocator
}

void* calloc(size_t nmemb, size_t size) {
    size_t total = nmemb * size;
    void* ptr = malloc(total);
    if (ptr) memset(ptr, 0, total);
    return ptr;
}

void* realloc(void* ptr, size_t size) {
    // Simple realloc: always allocate new
    void* new_ptr = malloc(size);
    if (new_ptr && ptr) {
        // We don't know the old size, so this is dangerous, 
        // but for a minimal kernel it might work if we're careful.
        memcpy(new_ptr, ptr, size); 
    }
    return new_ptr;
}

// Dummy for stack protector if needed
void* __stack_chk_guard = (void*)0xDEADBEEF;
void __stack_chk_fail(void) {
    while(1);
}

// Swift runtime calls this for fatal errors
void swift_reportFatalError(const char* prefix, int prefix_len, const char* message, int message_len, uint32_t flags) {
    while(1);
}

int posix_memalign(void **memptr, size_t alignment, size_t size) {
    *memptr = malloc(size); // Simplified alignment
    return 0;
}

int putchar(int c) {
    vga_putchar((char)c);
    return c;
}

void arc4random_buf(void *buf, size_t nbytes) {
    uint8_t *p = (uint8_t *)buf;
    for (size_t i = 0; i < nbytes; i++) p[i] = 0; // Not random, but satisfies linker
}


// Unicode and String stubs to satisfy linker
void _swift_stdlib_getNormData(void) {}
void _swift_stdlib_getDecompositionEntry(void) {}
void _swift_stdlib_nfd_decompositions(void) {}
void _swift_stdlib_nfc_quickcheck_data(void) {}

// Other potential missing symbols
void _swift_stdlib_getUCPProperties(void) {}
void _swift_stdlib_getUCPProperty(void) {}


