//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: Int, size: Point, destination: Point) -> Int {
        var grid = Grid<String>(size: size, fill: ".")
        populate(grid: &grid, input: input)
//        grid.draw()
        return grid.dijkstra(start: Point(x: 1, y: 1), end: destination, calculateScore: { _ in 1 }, canEnter: { point in grid[point] != "#" })
    }
    
    public func part2(_ input: Int, size: Point) -> Int {
        var grid = Grid<String>(size: size, fill: ".")
        populate(grid: &grid, input: input)
        var count = 0
        
        for x in 0..<grid.columns {
            for y in 0..<grid.rows {
                let point = Point(x: x, y: y)
                if grid[point] != "#" {
                    let cost = grid.dijkstra(start: Point(x: 1, y: 1), end: point, calculateScore: { _ in 1 }, canEnter: { point in grid[point] != "#" })
                    if cost >= 0, cost <= 50 {
                        count += 1
                    }
                }
            }
        }
        
        return count
    }
}

extension Day13 {
    func populate(grid: inout Grid<String>, input: Int) {
        for x in 0..<grid.columns {
            for y in 0..<grid.rows {
                let point = Point(x: x, y: y)
                let value = x * x + 3 * x + 2 * x * y + y + y * y + input
                if value.binary.reduce(0, { $0 + ($1 == "1" ? 1 : 0) }) % 2 != 0 {
                    grid[point] = "#"
                }
            }
        }
    }
}
