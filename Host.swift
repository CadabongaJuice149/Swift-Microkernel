/// Mach 3.0 Host and Processor Abstractions in Swift

public class Host {
    public static let shared = Host()
    public var info: HostInfo
    public var firstProcessor: UnsafeMutablePointer<ProcessorNode>?
    
    private init() {
        self.info = HostInfo(cpuType: 0, memorySize: 4096 * 1024 * 1024)
        self.firstProcessor = nil
    }
}

public struct HostInfo {
    public var cpuType: Int32
    public var memorySize: UInt64
}

public struct ProcessorNode {
    public var processor: Processor
    public var next: UnsafeMutablePointer<ProcessorNode>?
}

public class Processor {
    public let id: Int
    public var state: ProcessorState = .idle
    
    public init(id: Int) {
        self.id = id
    }
}

public enum ProcessorState {
    case idle
    case running
    case shutdown
}
