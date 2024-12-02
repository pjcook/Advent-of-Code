import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    
    let startNodeID = "AAA"
    let endNodeID = "ZZZ"
    
    public func part1(_ input: [String]) -> Int {
        let (directions, nodes) = parse(input)
        var count = 0
        var directionIndex = 0
        var node = nodes[startNodeID]!
        
        while node.id != endNodeID {
            count += 1
            
            let direction = directions[directionIndex]
            let nextID = direction == .left ? node.left : node.right
            node = nodes[nextID]!
            
            directionIndex += 1
            if directionIndex >= directions.count {
                directionIndex = 0
            }
        }
        
        return count
    }
    
    // RLA, AAA, JSA, RXA, QFA, QLA
    public func part2(_ input: [String]) -> Int {
        let (directions, nodes) = parse(input)
        var count = 0
        var directionIndex = 0
        var currentNodes = nodes.compactMap { $0.key.hasSuffix("A") ? $0.value : nil }
        var counts = Array(repeating: 0, count: currentNodes.count)

        while counts.contains(0) {
            count += 1
            
            let direction = directions[directionIndex]
            
            for i in (0..<currentNodes.count) {
                guard counts[i] == 0 else { continue }
                let node = currentNodes[i]
                let nextID = direction == .left ? node.left : node.right
                currentNodes[i] = nodes[nextID]!
                if nextID.hasSuffix("Z") {
                    counts[i] = count
                }
            }
            
            directionIndex += 1
            if directionIndex >= directions.count {
                directionIndex = 0
            }
        }
        
        // Find the prime factorization of the numbers and multiply together to find the smallest common number that they all go into, luckily all the minimum divisors already happen to be prime numbers
        var primeValues = Set<Int>()
        
        for count in counts {
            var i = 2
            while count % i != 0 {
                i += 1
            }
            primeValues.insert(i)
            primeValues.insert(count / i)
        }
        
        return primeValues.sorted().reduce(1, *)
    }
    
    public struct Node {
        public let id: String
        public let left: String
        public let right: String
    }
    
    public enum Direction: Character {
        case left = "L"
        case right = "R"
    }
}

extension Day8 {
    public func parse(_ input: [String]) -> ([Direction], [String:Node]) {
        let directions = input[0].map({ Direction(rawValue: $0)! })
        var nodes = [String:Node]()
        
        for i in (2..<input.count) {
            let line = input[i]
                .replacingOccurrences(of: " =", with: "")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: ",", with: "")
            guard !line.isEmpty else { continue }
            let components = line.components(separatedBy: " ")
            let node = Node(id: components[0], left: components[1], right: components[2])
            nodes[node.id] = node
        }
        
        return (directions, nodes)
    }
}
