/// Mach 3.0 Scheduler Abstraction in Swift

public class Scheduler {
    public static let shared = Scheduler()
    private var firstReadyThread: UnsafeMutablePointer<ThreadNode>?
    private let lock = SpinLock()
    
    private init() {}
    
    public func schedule(thread: Thread) {
        lock.acquire()
        defer { lock.release() }
        
        let newNode = UnsafeMutablePointer<ThreadNode>.allocate(capacity: 1)
        newNode.pointee = ThreadNode(thread: thread, next: nil)
        
        thread.state = .runnable
        
        if firstReadyThread == nil {
            firstReadyThread = newNode
        } else {
            var current = firstReadyThread
            while current?.pointee.next != nil {
                current = current?.pointee.next
            }
            current?.pointee.next = newNode
        }
    }
    
    public func pickNextThread() -> Thread? {
        lock.acquire()
        defer { lock.release() }
        
        if let node = firstReadyThread {
            let thread = node.pointee.thread
            firstReadyThread = node.pointee.next
            thread.state = .running
            return thread
        }
        
        return nil
    }
    
    public func yield() {
        // Yield logic
    }
}
