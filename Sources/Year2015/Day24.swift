import Foundation
import StandardLibraries

public class Day24 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let third = input.reduce(0, +) / 3
        let queue = PriorityQueue<QueueItem>()
        queue.enqueue(QueueItem(current: [], groups: [], remaining: input.sorted().reversed(), totalSoFar: 0), priority: 0)
        var smallest = Int.max
        var smallestCount = Int.max

        while let queueItem = queue.dequeue() {
            if queueItem.groups.count == 2 {
                var newGroups = queueItem.groups
                // to stop arithmetic overflow
                var calc = 1
                let largest = queueItem.groups.sorted().last!
                for e in (queueItem.current+queueItem.remaining) {
                    calc *= e
                    if calc > largest {
                        break
                    }
                }
                newGroups.append(calc)
                let qe = newGroups.sorted().first!
                if qe < smallest {
                    smallest = qe
                    print("smallest", qe)
                }
                continue
            }
            
            var totalSoFar = queueItem.totalSoFar
            var groups = queueItem.groups
            var current = queueItem.current
            if totalSoFar == third {
                let qe = current.reduce(1, *)
                groups.append(qe)
                smallestCount = min(smallestCount, current.count)
                if qe < smallest {
                    smallest = qe
                    break
                }
                smallest = min(smallest, qe)
                current = []
                totalSoFar = 0
            }
            
            guard totalSoFar < third else { continue }
            for item in queueItem.remaining where totalSoFar + item <= third {
                let newRemainder = queueItem.remaining.filter({ $0 != item })
                queue.enqueue(QueueItem(current: (current + [item]).sorted(), groups: groups, remaining: newRemainder, totalSoFar: totalSoFar + item), priority: -(totalSoFar + item))
            }
        }
        
        return smallest
    }
    
    public func part2(_ input: [Int]) -> Int {
        let quarter = input.reduce(0, +) / 4
        let queue = PriorityQueue<QueueItem>()
        queue.enqueue(QueueItem(current: [], groups: [], remaining: input.sorted().reversed(), totalSoFar: 0), priority: 0)
        var smallest = Int.max
        var smallestCount = Int.max

        while let queueItem = queue.dequeue() {
            if queueItem.groups.count == 3 {
                var newGroups = queueItem.groups
                // to stop arithmetic overflow
                var calc = 1
                let largest = queueItem.groups.sorted().last!
                for e in (queueItem.current+queueItem.remaining) {
                    calc *= e
                    if calc > largest {
                        break
                    }
                }
                newGroups.append(calc)
                let qe = newGroups.sorted().first!
                if qe < smallest {
                    smallest = qe
                    print("smallest", qe)
                }
                continue
            }
            
            var totalSoFar = queueItem.totalSoFar
            var groups = queueItem.groups
            var current = queueItem.current
            if totalSoFar == quarter {
                let qe = current.reduce(1, *)
                groups.append(qe)
                smallestCount = min(smallestCount, current.count)
                if qe < smallest && smallest != Int.max {
                    smallest = min(smallest, qe)
                    print("lo", smallest)
                    break
                }
                smallest = min(smallest, qe)
                current = []
                totalSoFar = 0
            }
            
            guard totalSoFar < quarter else { continue }
            for item in queueItem.remaining where totalSoFar + item <= quarter {
                let newRemainder = queueItem.remaining.filter({ $0 != item })
                queue.enqueue(QueueItem(current: (current + [item]).sorted(), groups: groups, remaining: newRemainder, totalSoFar: totalSoFar + item), priority: -(totalSoFar + item))
            }
        }
        
        return smallest
    }
    
    struct QueueItem: Hashable {
        let current: [Int]
        let groups: [Int]
        let remaining: [Int]
        let totalSoFar: Int
    }
}
