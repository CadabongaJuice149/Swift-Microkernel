/// Mach 3.0 Port Abstraction in Swift
/// A port is a kernel-protected communication channel.

public enum PortRightType: UInt32 {
    case receive = 1
    case send = 2
    case sendOnce = 3
    case portSet = 4
    case deadName = 5
}

public class Port {
    public let id: UInt64
    public var receiver: Task?
    // Use a simple linked list for messages to avoid Array
    public var firstMessage: UnsafeMutablePointer<MessageNode>?
    public let lock = SpinLock()
    
    public init(id: UInt64) {
        self.id = id
        self.firstMessage = nil
    }
}

public struct MessageNode {
    public var message: Message
    public var next: UnsafeMutablePointer<MessageNode>?
}

public struct PortRight {
    public let port: Port
    public var type: PortRightType
    public var makeSendCount: UInt32 = 0
    
    public init(port: Port, type: PortRightType) {
        self.port = port
        self.type = type
    }
}

public class IPCSpace {
    // Use a simple fixed-size array for rights to avoid Dictionary
    public var rights = UnsafeMutablePointer<PortRight?>.allocate(capacity: 1024)
    public let lock = SpinLock()
    
    public init() {
        for i in 0..<1024 {
            rights[i] = nil
        }
    }
    
    public func lookup(name: UInt32) -> PortRight? {
        if name >= 1024 { return nil }
        return rights[Int(name)]
    }
}
