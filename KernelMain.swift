/// Main entry point for the Swift-Mach Microkernel

@_cdecl("kernel_main")
public func kernel_main() {
    kprint("Initializing Swift-Mach Microkernel...\n")
    
    // 1. Initialize Memory Management
    let kernelMap = VMMap()
    let kernelTask = Task(id: 0, map: kernelMap)
    
    // 2. Initialize IPC
    let bootstrapPort = Port(id: 1)
    kernelTask.ipcSpace.rights[1] = PortRight(port: bootstrapPort, type: .receive)
    
    // 3. Initialize Scheduler
    let mainThread = Thread(id: 0, task: kernelTask)
    Scheduler.shared.schedule(thread: mainThread)
    
    // 4. Handover to Architecture Bootstrap
    ArchX86.boot()
}
