# Swift-Mach Microkernel

A Swift-language microkernel implementation based on the Mach 3.0 architecture. This project aims to provide a pure microkernel core written in Apple Swift, utilizing the latest Embedded Swift features.

## Architecture

The kernel is structured into several core subsystems, mirroring the original Mach 3.0 design:

### 1. Inter-Process Communication (IPC)
- **Ports**: Kernel-protected communication endpoints.
- **Port Rights**: Task-specific rights to access ports (Send, Receive, Send-Once).
- **Messages**: The fundamental unit of communication.
- **MachMsg**: The core system call for sending and receiving messages.

### 2. Virtual Memory (VM)
- **VMMap**: Manages the address space of a task.
- **VMMapping**: Represents a region of virtual memory.
- **VMManager**: Handles page faults and memory object management.

### 3. Kernel Core (Kern)
- **Tasks**: Resource containers (address space, port rights).
- **Threads**: Units of execution.
- **Scheduler**: Manages thread execution using a round-robin strategy.
- **Locks**: Spinlocks for kernel synchronization.

### 4. Architecture (Arch)
- **x86 Bootstrap**: Initializing the CPU state and jumping to the kernel entry point.

### 5. Device Interface
- **Generic Device Protocol**: Allows for clean integration of device drivers.

## Building

The project uses a standard `Makefile` and is designed to be compiled with the Swift 6.3.3 toolchain.

### Prerequisites
- Swift 6.3.3 Toolchain
- `ld` linker
- `make`

### Build Commands
```bash
make all
```
This will generate a `kernel.bin` which can be booted via a Multiboot-compliant bootloader.

## Sourcing

The original Mach 3.0 source code was retrieved from the CMU AFS tree at `https://www.cs.cmu.edu/afs/cs/project/mach/public/`.
