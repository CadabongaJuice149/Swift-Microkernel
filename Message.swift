/// Mach 3.0 Message Abstraction in Swift

public struct MessageHeader {
    public var msgh_bits: UInt32
    public var msgh_size: UInt32
    public var msgh_remote_port: UInt32
    public var msgh_local_port: UInt32
    public var msgh_reserved: UInt32
    public var msgh_id: Int32
}

public struct Message {
    public var header: MessageHeader
    public var body: UnsafeMutablePointer<UInt8>?
    
    public init(header: MessageHeader, body: UnsafeMutablePointer<UInt8>?) {
        self.header = header
        self.body = body
    }
}
