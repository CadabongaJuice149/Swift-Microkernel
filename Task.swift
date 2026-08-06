/// Mach 3.0 Task Abstraction in Swift

public class Task {
    public let id: UInt64
    public var ipcSpace: IPCSpace
    public var firstThread: UnsafeMutablePointer<ThreadNode>?
    public var map: VMMap
    
    public init(id: UInt64, map: VMMap) {
        self.id = id
        self.ipcSpace = IPCSpace()
        self.map = map
        self.firstThread = nil
    }
}

public struct ThreadNode {
    public var thread: Thread
    public var next: UnsafeMutablePointer<ThreadNode>?
}

public class Thread {
    public let id: UInt64
    public var task: Task?
    public var state: ThreadState
    
    public init(id: UInt64, task: Task) {
        self.id = id
        self.task = task
        self.state = .runnable
    }
}

public enum ThreadState {
    case runnable
    case running
    case blocked
    case terminated
}
