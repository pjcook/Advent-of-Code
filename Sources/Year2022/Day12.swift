//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    public let endItem = 27
    
    public func part1(_ input: [String]) -> Int {
        let grid = parse(input, startItem: 0)
        let startIndex = grid.items.firstIndex(of: 0)!
        let endIndex = grid.items.firstIndex(of: endItem)!
        let start = grid.point(for: startIndex)
        let end = grid.point(for: endIndex)

        return calculatePath(from: start, to: end, grid: grid)
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input, startItem: 1)
        let endIndex = grid.items.firstIndex(of: endItem)!
        let end = grid.point(for: endIndex)
        return calculatePath(from: end, grid: grid)
    }
}

extension Day12 {
    func calculatePath(from start: Point, to end: Point, grid: Grid<Int>) -> Int {
        let maxPoint = grid.bottomRight
        
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            let currentValue = grid[current]
            if current == end {
                break
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                guard grid[next] - currentValue <= 1 else { continue }
                let newCost = costSoFar[current, default: 0] + 1
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[end, default: -1]
    }
    
    func calculatePath(from end: Point, grid: Grid<Int>) -> Int {
        let maxPoint = grid.bottomRight
        
        let queue = PriorityQueue<Point>()
        queue.enqueue(end, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[end] = 0
        var start = end

        while !queue.isEmpty {
            let current = queue.dequeue()!
            let currentValue = grid[current]
            if currentValue == 1 {
                start = current
                break
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                guard grid[next] - currentValue >= -1 else { continue }
                let newCost = costSoFar[current, default: 0] + 1
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[start, default: -1]
    }
}

extension Day12 {
    public func parse(_ input: [String], startItem: Int) -> Grid<Int> {
        var items = [Int]()
        let alphabet = "abcdefghijklmnopqrstuvwxyz".map({ Character(String($0)) })

        for line in input {
            line.forEach {
                if $0 == "S" {
                    items.append(startItem)
                } else if $0 == "E" {
                    items.append(endItem)
                } else {
                    items.append(alphabet.firstIndex(of: $0)! + 1)
                }
            }
        }
        
        let columns = input[0].count
        return Grid(columns: columns, items: items)
    }
}
