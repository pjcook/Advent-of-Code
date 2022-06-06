import Foundation

public class Ring<Value: Hashable>: Hashable {
    public static func == (lhs: Ring<Value>, rhs: Ring<Value>) -> Bool {
        lhs.values == rhs.values
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(index)
    }
    
    private var values: [Value]
    private var index = 0
    
    public init(_ values: [Value]) {
        self.values = values
    }
    
    public func next() -> Value? {
        guard !values.isEmpty else { return nil }
        let value = values[index]
        index += 1
        if index >= values.count {
            index = 0
        }
        return value
    }
}
