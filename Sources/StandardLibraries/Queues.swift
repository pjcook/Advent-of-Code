import Foundation

public class PriorityQueue<T: Hashable> {
    public init() {}
    public var queue = [T:Int]()
    public var isEmpty: Bool {
        queue.isEmpty
    }
    
    public func enqueue(_ item: T, priority: Int) {
        queue[item] = priority
    }
    
    public func dequeue() -> T? {
        guard !queue.isEmpty else { return nil }
        let item = queue.sorted { p1, p2 in
            p1.value < p2.value
        }.first!.key
        queue.removeValue(forKey: item)
        return item
    }
}
