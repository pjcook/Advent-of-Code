//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid(input)
        let total = grid.columns * 2 + grid.rows * 2 - 4
        var points = Set<Point>()
        
        for y in (1..<grid.columns-1) {
            for x in (1..<grid.rows-1) {
                let point = Point(x, y)
                let value = grid[point]
                // Check left
                if (0..<x).map({ Point($0, y) }).first(where: { grid[$0] >= value }) == nil {
                    points.insert(point)
                    continue
                }
                
                // Check right
                if (x+1..<grid.columns).map({ Point($0, y) }).first(where: { grid[$0] >= value }) == nil {
                    points.insert(point)
                    continue
                }
                
                // Check top
                if (0..<y).map({ Point(x, $0) }).first(where: { grid[$0] >= value }) == nil {
                    points.insert(point)
                    continue
                }
                
                // Check bottom
                if (y+1..<grid.rows).map({ Point(x, $0) }).first(where: { grid[$0] >= value }) == nil {
                    points.insert(point)
                    continue
                }
            }
        }

        return total + points.count
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = Grid(input)
        var highestScenicScore = 0
        
        for y in (1..<grid.columns-1) {
            for x in (1..<grid.rows-1) {
                let point = Point(x, y)
                let value = grid[point]
                                
                let left = ((0..<x).map({ Point($0, y) }).reversed().firstIndex(where: { grid[$0] >= value }) ?? x-1) + 1
                let right = ((x+1..<grid.columns).map({ Point($0, y) }).firstIndex(where: { grid[$0] >= value }) ?? (grid.columns-1)-(x+1)) + 1
                let top = ((0..<y).map({ Point(x, $0) }).reversed().firstIndex(where: { grid[$0] >= value }) ?? y-1) + 1
                let bottom = ((y+1..<grid.rows).map({ Point(x, $0) }).firstIndex(where: { grid[$0] >= value }) ?? (grid.rows-1)-(y+1)) + 1
                
                let scenicScore = left * right * top * bottom

                if scenicScore > highestScenicScore {
                    highestScenicScore = scenicScore
                }
            }
        }

        return highestScenicScore
    }
}


