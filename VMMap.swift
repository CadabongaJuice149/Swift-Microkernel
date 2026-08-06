/// Mach 3.0 Virtual Memory Map Abstraction in Swift

public class VMMap {
    public var firstMapping: UnsafeMutablePointer<VMMappingNode>?
    public let lock = SpinLock()
    
    public init() {}
    
    public func map(address: UInt64, size: UInt64, protection: VMProtection) {
        lock.acquire()
        defer { lock.release() }
        
        let newNode = UnsafeMutablePointer<VMMappingNode>.allocate(capacity: 1)
        newNode.pointee = VMMappingNode(mapping: VMMapping(address: address, size: size, protection: protection), next: nil)
        
        if firstMapping == nil {
            firstMapping = newNode
        } else {
            var current = firstMapping
            while current?.pointee.next != nil {
                current = current?.pointee.next
            }
            current?.pointee.next = newNode
        }
    }
}

public struct VMMappingNode {
    public var mapping: VMMapping
    public var next: UnsafeMutablePointer<VMMappingNode>?
}

public struct VMMapping {
    public var address: UInt64
    public var size: UInt64
    public var protection: VMProtection
}

public struct VMProtection: OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let read = VMProtection(rawValue: 1 << 0)
    public static let write = VMProtection(rawValue: 1 << 1)
    public static let execute = VMProtection(rawValue: 1 << 2)
}
