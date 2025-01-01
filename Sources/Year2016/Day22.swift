//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
    
    typealias NodeList = [Node]
    
    public func part1(_ input: [String]) -> Int {
        let nodes = input[2...].map(Node.init)
        var count = 0
        for n1 in nodes where n1.used > 0 {
            count += nodes.filter {
                $0.point != n1.point && $0.available >= n1.used
            }.count
        }
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        let nodes = input[2...].map(Node.init)
        let (_, xp) = nodes.map({ $0.point }).extremes()
        let dataPosition = Point(xp.x, 0)
        let hash = generateGridHash(for: nodes, dataPosition: dataPosition)
        var seen = [hash: 0]
        return solve(nodes: nodes, depth: 0, dataPosition: dataPosition, seen: &seen)
    }
    
    struct Move: Hashable {
        let nodes: NodeList
        let depth: Int
        let dataPosition: Point
    }
    
    func solve(nodes: NodeList, depth: Int, dataPosition: Point, seen: inout [String: Int]) -> Int {
        var minPath = Int.max
        let queue = PriorityQueue<Move>()
        queue.enqueue(Move(nodes: nodes, depth: depth, dataPosition: dataPosition), priority: 0)
        
        while !queue.isEmpty {
            let move = queue.dequeue()!
            guard move.depth < minPath else { continue }

            for (from, to) in viableMoves(nodes: move.nodes) {
                var next = move.nodes
                let fromIndex = next.firstIndex(where: { $0.point == from })!
                let toIndex = next.firstIndex(where: { $0.point == to })!
                let n1 = next[fromIndex]
                let n2 = next[toIndex]
                next[toIndex] = n2.addData(amount: n1.used)
                next[fromIndex] = n1.clearData()
                var dp = move.dataPosition
                if dp == n1.point {
                    dp = n2.point
                }
                let hash = generateGridHash(for: next, dataPosition: dp)
                if seen[hash] == nil || seen[hash]! > move.depth + 1 {
                    seen[hash] = move.depth + 1
                    if move.dataPosition == n1.point, n2.point == .zero {
                        minPath = min(minPath, move.depth + 1)
                        return minPath
                    }
                    let emptyNodePosition = next.first { $0.used == 0 }.map { $0.point } ?? .zero
                    queue.enqueue(Move(nodes: next, depth: move.depth + 1, dataPosition: dp), priority: emptyNodePosition.manhattanDistance(to: dp) + dp.manhattanDistance(to: .zero) + move.depth)
                }
            }
        }
        
        return minPath
    }
    
    func viableMoves(nodes: NodeList) -> [(Point, Point)] {
        var results = [(Point, Point)]()
        
        for n1 in nodes where n1.used > 0 {
            for n2 in nodes {
                if n2.point != n1.point && n2.available >= n1.used && n1.point.isCardinalNeighbor(of: n2.point) {
                    results.append((n1.point, n2.point))
                }
            }
        }

        return results
    }
    
    func generateGridHash(for nodes: NodeList, dataPosition: Point) -> String {
        nodes.filter({ $0.used == 0 || $0.point == dataPosition }).sorted(by: { $0.point < $1.point }).map({ $0.hash }).joined()
    }
    
    struct Node: Hashable {
        let point: Point
        let size: Int
        let used: Int
        let available: Int
        let hash: String
        
        init(_ value: String) {
            let parts = value
                .replacingOccurrences(of: "     ", with: " ")
                .replacingOccurrences(of: "    ", with: " ")
                .replacingOccurrences(of: "   ", with: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .replacingOccurrences(of: "T", with: "")
                .dropLast()
                .split(separator: " ")
            
            let nodeParts = parts[0].split(separator: "-")
            self.point = Point(Int(nodeParts[1].replacingOccurrences(of: "x", with: ""))!, Int(nodeParts[2].replacingOccurrences(of: "y", with: ""))!)
            self.size = Int(parts[1])!
            self.used = Int(parts[2])!
            self.available = Int(parts[3])!
            self.hash = "x:" + String(point.x) + " y:" + String(point.y) + "s:" + String(size) + "u:" + String(used) + "a:" + String(available)
        }
        
        init(point: Point, size: Int, used: Int = 0) {
            self.point = point
            self.size = size
            self.used = used
            self.available = size - used
            self.hash = "x:" + String(point.x) + " y:" + String(point.y) + "s:" + String(size) + "u:" + String(used) + "a:" + String(available)
        }
        
        func clearData() -> Node {
            Node(point: point, size: size)
        }
        
        func addData(amount: Int) -> Node {
            Node(point: point, size: size, used: used + amount)
        }
    }
}
