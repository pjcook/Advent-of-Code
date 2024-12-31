//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public final class Day17 {
    public init() {}
    private var cache = [String: [Bool]]()
    
    public func part1(_ input: String) -> String {
        cache = [:]
        let grid = Grid<String>(size: Point(4,4), fill: ".")
        let start = Point.zero
        let end = Point(3,3)
        return grid.dijkstra(start: start, end: end, maxPoint: grid.bottomRight, initialHistory: input, calculateScore: { _ in 1 }, canEnter: { path, next in
            var options: [Bool]!
            if let values = cache[path.history] {
                options = values
            } else {
                options = generateMD5Hash(for: path.history).prefix(4).map(isOpen)
                cache[path.history] = options
            }

            // up, down, left, right
            guard next.isValid(max: grid.bottomRight) else { return false }
            switch directionString(from: path.point, to: next) {
            case "U": return options[0]
            case "D": return options[1]
            case "L": return options[2]
            case "R": return options[3]
            default: fatalError("oops")
            }
        })
    }
    
    public func part2(_ input: String) -> Int {
        cache = [:]
        let grid = Grid<String>(size: Point(4,4), fill: ".")
        let start = Point.zero
        let end = Point(3,3)
        return grid.dijkstraLongest(start: start, end: end, maxPoint: grid.bottomRight, initialHistory: input, calculateScore: { _ in 1 }, canEnter: { path, next in
            var options: [Bool]!
            if let values = cache[path.history] {
                options = values
            } else {
                options = generateMD5Hash(for: path.history).prefix(4).map(isOpen)
                cache[path.history] = options
            }

            // up, down, left, right
            guard next.isValid(max: grid.bottomRight) else { return false }
            switch directionString(from: path.point, to: next) {
            case "U": return options[0]
            case "D": return options[1]
            case "L": return options[2]
            case "R": return options[3]
            default: fatalError("oops")
            }
        }).count
    }
}

extension Day17 {
    func isOpen(_ c: Character) -> Bool {
        ["b","c","d","e","f"].contains(c)
    }
}

struct Path: Hashable {
    let point: Point
    let history: String
}

func directionString(from current: Point, to next: Point) -> String {
    if current.up() == next { return "U" }
    if current.down() == next { return "D" }
    if current.left() == next { return "L" }
    if current.right() == next { return "R" }
    fatalError("oops")
}

extension Grid where T == String {
    func dijkstra(start: Point, end: Point, maxPoint: Point, initialHistory: String, calculateScore: (Point) -> Int, canEnter: (Path, Point) -> Bool) -> String {
        let queue = PriorityQueue<Path>()
        queue.enqueue(Path(point: start, history: initialHistory), priority: 0)
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current.point == end {
                return String(current.history.suffix(current.history.count - initialHistory.count))
            }
            
            for next in current.point.cardinalNeighbors(max: maxPoint) {
                guard canEnter(current, next) else { continue }
                let newCost = current.history.count - initialHistory.count + calculateScore(next)
                queue.enqueue(Path(point: next, history: current.history + directionString(from: current.point, to: next)), priority: newCost)
            }
        }
        
        return "-1"
    }
    
    func dijkstraLongest(start: Point, end: Point, maxPoint: Point, initialHistory: String, calculateScore: (Point) -> Int, canEnter: (Path, Point) -> Bool) -> String {
        let queue = PriorityQueue<Path>()
        queue.enqueue(Path(point: start, history: initialHistory), priority: 0)
        var last = ""
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current.point == end {
                last = String(current.history.suffix(current.history.count - initialHistory.count))
                continue
            }
            
            for next in current.point.cardinalNeighbors(max: maxPoint) {
                guard canEnter(current, next) else { continue }
                let newCost = current.history.count - initialHistory.count + calculateScore(next)
                queue.enqueue(Path(point: next, history: current.history + directionString(from: current.point, to: next)), priority: newCost)
            }
        }
        
        return last
    }
}
