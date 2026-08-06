SWIFT = /opt/swift/usr/bin/swiftc
LINKER = /usr/bin/ld
SWIFT_FLAGS = -enable-experimental-feature Embedded -enable-experimental-feature Extern -nostdlibimport -target i686-unknown-none-elf -wmo \
              -Xcc -fno-stack-protector -Xcc -fno-PIC -Xfrontend -disable-objc-interop

LDFLAGS = -T Sources/Kernel/Arch/i386/linker.ld -m elf_i386

SOURCES = $(shell find Sources/Kernel -name "*.swift")
ASM_SOURCES = $(shell find Sources/Kernel -name "*.S")
C_SOURCES = $(shell find Sources/Kernel -name "*.c")
ASM_OBJECTS = $(ASM_SOURCES:.S=.o)
C_OBJECTS = $(C_SOURCES:.c=.o)
OBJECTS = Kernel.o $(ASM_OBJECTS) $(C_OBJECTS)

LIBGCC = $(shell gcc -m32 -print-libgcc-file-name)

all: kernel.bin

kernel.bin: $(OBJECTS)
	$(LINKER) $(LDFLAGS) -o $@ $^ $(LIBGCC)

Kernel.o: $(SOURCES)
	$(SWIFT) $(SWIFT_FLAGS) -c $(SOURCES) -o $@

%.o: %.S
	as --32 $< -o $@

%.o: %.c
	gcc -m32 -ffreestanding -fno-stack-protector -fno-pic -c $< -o $@

clean:
	rm -f $(OBJECTS) kernel.bin
