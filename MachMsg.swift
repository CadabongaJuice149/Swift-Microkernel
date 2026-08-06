/// Mach 3.0 IPC Message Passing Logic

public enum MachMsgResult: Int32 {
    case success = 0
    case invalidRemotePort = 1
    case invalidLocalPort = 2
    case sendFailed = 3
    case receiveFailed = 4
    case bufferTooSmall = 5
}

public class MachIPC {
    public static let shared = MachIPC()
    private let lock = SpinLock()
    
    private init() {}
    
    public func mach_msg(
        header: inout MessageHeader,
        option: UInt32,
        sendSize: UInt32,
        receiveSize: UInt32,
        receiveName: UInt32,
        timeout: UInt32,
        notify: UInt32
    ) -> MachMsgResult {
        if (option & 0x1) != 0 {
            let result = send(header: header, size: sendSize)
            if result != .success { return result }
        }
        if (option & 0x2) != 0 {
            let result = receive(header: &header, size: receiveSize, name: receiveName)
            if result != .success { return result }
        }
        return .success
    }
    
    private func send(header: MessageHeader, size: UInt32) -> MachMsgResult {
        lock.acquire()
        defer { lock.release() }
        
        guard let port = MachPortManager.shared.lookupPort(id: UInt64(header.msgh_remote_port)) else {
            return .invalidRemotePort
        }
        
        let newNode = UnsafeMutablePointer<MessageNode>.allocate(capacity: 1)
        newNode.pointee = MessageNode(message: Message(header: header, body: nil), next: nil)
        
        if port.firstMessage == nil {
            port.firstMessage = newNode
        } else {
            var current = port.firstMessage
            while current?.pointee.next != nil {
                current = current?.pointee.next
            }
            current?.pointee.next = newNode
        }
        
        kprint("Kernel: Sent message\n")
        return .success
    }
    
    private func receive(header: inout MessageHeader, size: UInt32, name: UInt32) -> MachMsgResult {
        lock.acquire()
        defer { lock.release() }
        
        guard let port = MachPortManager.shared.lookupPort(id: UInt64(name)) else {
            return .invalidLocalPort
        }
        
        if let node = port.firstMessage {
            header = node.pointee.message.header
            port.firstMessage = node.pointee.next
            // node.deallocate() // In a real kernel, we would free the node
            kprint("Kernel: Received message\n")
            return .success
        } else {
            kprint("Kernel: Receiver would block\n")
            return .success
        }
    }
}
