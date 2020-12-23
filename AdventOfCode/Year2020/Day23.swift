import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
       public func part1(_ input: [Int]) -> Int {
        var cups = [Int: LinkedNode]()
        let head = LinkedNode(value: input.first!)
        var next = head
        cups[head.value] = head
        
        for i in 1..<input.count {
            let node = LinkedNode(value: input[i])
            next.next = node
            next = node
            cups[node.value] = node
        }
        
        next.next = head
        return solve(head, cups.count, cups, turns: 100)
    }
    
    public func part2(_ input: [Int]) -> Int {
        var cups = [Int: LinkedNode]()
        let head = LinkedNode(value: input.first!)
        var next = head
        cups[head.value] = head
        
        for i in 1..<input.count {
            let node = LinkedNode(value: input[i])
            next.next = node
            next = node
            cups[node.value] = node
        }
        
        let maxValue = 1_000_000
        for i in 10...maxValue {
            let node = LinkedNode(value: i)
            next.next = node
            next = node
            cups[node.value] = node
        }

        next.next = head
        return solve(head, cups.count, cups, turns: 10_000_000)
    }
    
    func solve(_ head: LinkedNode, _ maxValue: Int, _ cups: [Int : Day23.LinkedNode], turns: Int) -> Int {
        var current = head
        
        for _ in 0..<turns {
            let removed = current.next!
            current.next = current.next!.next!.next!.next
            var destinationValue = current.value == 1 ? maxValue : current.value - 1
            let notOneOfThese = [removed.value, removed.next!.value, removed.next!.next!.value]
            while notOneOfThese.contains(destinationValue) {
                destinationValue -= 1
                if destinationValue == 0 {
                    destinationValue = maxValue
                }
            }
            let insertNode = cups[destinationValue]!
            removed.next!.next!.next = insertNode.next
            insertNode.next = removed
            current = current.next!
        }
        
        if turns == 100 {
            var output = [Int]()
            let first = cups[1]!
            var next = first.next!
            while next.value != first.value {
                output.append(next.value)
                next = next.next!
            }
            return Int(output.map({ String($0) }).joined())!
        } else {
            let one = cups[1]!
            let num1 = one.next!.value
            let num2 = one.next!.next!.value
            return num1 * num2
        }
    }
    
    class LinkedNode {
        let value: Int
        var next: LinkedNode?
        init(value: Int) {
            self.value = value
        }
    }
}
