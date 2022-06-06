import Foundation

public class LinkedNode<Value> {
    public let value: Value
    public var next: LinkedNode<Value>?
    public init(value: Value) {
        self.value = value
    }
}

public class DoubleLinkedNode<Value> {
    public let value: Value
    public var previous: DoubleLinkedNode<Value>?
    public var next: DoubleLinkedNode<Value>?
    public init(value: Value) {
        self.value = value
    }
}
