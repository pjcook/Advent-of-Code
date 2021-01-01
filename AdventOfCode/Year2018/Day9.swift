import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}
    
    public func solve(_ lastMarble: Int, players: Int) -> Int {
        var scores = [Int: Int]()
        var player = 1
        var current = DoubleLinkedNode(value: 0)
        let next = DoubleLinkedNode(value: 1)
        next.next = current
        next.previous = current
        current.next = next
        current.previous = next
        current = next

        
        for i in (2...lastMarble) {
            if i % 23 == 0 {
                current = current.previous!.previous!.previous!.previous!.previous!.previous!.previous!.previous!
                let value = current.next!.value
                let next = current.next!.next!
                current.next = next
                next.previous = current
                scores[player] = scores[player, default: 0] + value + i
                current = next
            } else {
                current = current.next!
                let next = current.next!
                let node = DoubleLinkedNode(value: i)
                node.next = next
                node.previous = current
                current.next = node
                next.previous = node
                current = node
            }
            
            player += 1
            if player > players {
                player = 1
            }
        }
        
        return scores.values.sorted().last!
    }
}
