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
    
    public func part1(_ grid: Grid<Int>) -> Int {
        var total = grid.columns * 2 + grid.rows * 2 - 4
        
        for y in (1..<grid.columns-1) {
            for x in (1..<grid.rows-1) {
                let point = Point(x, y)
                let value = grid[point]
                
                if
                    visibleFromLeft(point: point, grid: grid, value: value) ||
                    visibleFromRight(point: point, grid: grid, value: value) ||
                    visibleFromTop(point: point, grid: grid, value: value) ||
                    visibleFromBottom(point: point, grid: grid, value: value)
                {
                    total += 1
                    continue
                }
            }
        }

        return total
    }
    
    func visibleFromLeft(point: Point, grid: Grid<Int>, value: Int) -> Bool {
        (0..<point.x).map({ Point($0, point.y) }).first(where: { grid[$0] >= value }) == nil
    }
    
    func visibleFromRight(point: Point, grid: Grid<Int>, value: Int) -> Bool {
        (point.x+1..<grid.columns).map({ Point($0, point.y) }).first(where: { grid[$0] >= value }) == nil
    }
    
    func visibleFromTop(point: Point, grid: Grid<Int>, value: Int) -> Bool {
        (0..<point.y).map({ Point(point.x, $0) }).first(where: { grid[$0] >= value }) == nil
    }
    
    func visibleFromBottom(point: Point, grid: Grid<Int>, value: Int) -> Bool {
        (point.y+1..<grid.rows).map({ Point(point.x, $0) }).first(where: { grid[$0] >= value }) == nil
    }
    
    public func part2(_ grid: Grid<Int>) -> Int {
        var highestScenicScore = 0
        
        for y in (1..<grid.columns-1) {
            for x in (1..<grid.rows-1) {
                let point = Point(x, y)
                let value = grid[point]
                                
                let scenicScore =
                    visibleToLeft(point: point, grid: grid, value: value) *
                    visibleToRight(point: point, grid: grid, value: value) *
                    visibleToTop(point: point, grid: grid, value: value) *
                    visibleToBottom(point: point, grid: grid, value: value)
                
                if scenicScore > highestScenicScore {
                    highestScenicScore = scenicScore
                }
            }
        }

        return highestScenicScore
    }
    
    func visibleToLeft(point: Point, grid: Grid<Int>, value: Int) -> Int {
        ((0..<point.x).map({ Point($0, point.y) }).reversed().firstIndex(where: { grid[$0] >= value }) ?? point.x-1) + 1
    }
    
    func visibleToRight(point: Point, grid: Grid<Int>, value: Int) -> Int {
        ((point.x+1..<grid.columns).map({ Point($0, point.y) }).firstIndex(where: { grid[$0] >= value }) ?? (grid.columns-1)-(point.x+1)) + 1
    }
    
    func visibleToTop(point: Point, grid: Grid<Int>, value: Int) -> Int {
        ((0..<point.y).map({ Point(point.x, $0) }).reversed().firstIndex(where: { grid[$0] >= value }) ?? point.y-1) + 1
    }
    
    func visibleToBottom(point: Point, grid: Grid<Int>, value: Int) -> Int {
        ((point.y+1..<grid.rows).map({ Point(point.x, $0) }).firstIndex(where: { grid[$0] >= value }) ?? (grid.rows-1)-(point.y+1)) + 1
    }
}


