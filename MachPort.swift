/// Mach 3.0 Port Management in Swift

public class MachPortManager {
    public static let shared = MachPortManager()
    private var nextPortId: UInt64 = 100
    // Use a fixed-size array for all ports
    private var allPorts = UnsafeMutablePointer<Port?>.allocate(capacity: 1024)
    private let lock = SpinLock()
    
    private init() {
        for i in 0..<1024 {
            allPorts[i] = nil
        }
    }
    
    public func allocate(task: Task) -> UInt32 {
        lock.acquire()
        defer { lock.release() }
        
        let portId = nextPortId
        nextPortId += 1
        
        let port = Port(id: portId)
        port.receiver = task
        
        let index = Int(portId % 1024)
        allPorts[index] = port
        
        let name = UInt32(portId % 1024)
        task.ipcSpace.rights[Int(name)] = PortRight(port: port, type: .receive)
        
        return name
    }
    
    public func lookupPort(id: UInt64) -> Port? {
        let index = Int(id % 1024)
        return allPorts[index]
    }
}
