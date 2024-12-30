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
        var grid = Grid<String>(size: Point(50, 6), fill: ".")
        
        for line in input {
            switch parse(line) {
            case let .rect(size):
                for x in 0..<size.x {
                    for y in 0..<size.y {
                        grid[x, y] = "#"
                    }
                }
                
            case let .rotateRow(rowID, distance):
                var row = grid.row(at: rowID)
                let items = row.suffix(distance)
                row.removeLast(distance)
                row = items + row
                
                for x in 0..<row.count {
                    grid[x,rowID] = row[x]
                }
                
            case let .rotateCol(colID, distance):
                var column = grid.column(at: colID)
                let items = column.suffix(distance)
                column.removeLast(distance)
                column = items + column
                
                for y in 0..<column.count {
                    grid[colID,y] = column[y]
                }
            }
        }
                
        return grid.items.filter({ $0 == "#" }).count
    }
    
    public func part2(_ input: [String]) -> Int {
        var grid = Grid<String>(size: Point(50, 6), fill: ".")
        
        for line in input {
            switch parse(line) {
            case let .rect(size):
                for x in 0..<size.x {
                    for y in 0..<size.y {
                        grid[x, y] = "#"
                    }
                }
                
            case let .rotateRow(rowID, distance):
                var row = grid.row(at: rowID)
                let items = row.suffix(distance)
                row.removeLast(distance)
                row = items + row
                
                for x in 0..<row.count {
                    grid[x,rowID] = row[x]
                }
                
            case let .rotateCol(colID, distance):
                var column = grid.column(at: colID)
                let items = column.suffix(distance)
                column.removeLast(distance)
                column = items + column
                
                for y in 0..<column.count {
                    grid[colID,y] = column[y]
                }
            }
        }
        
        grid.draw()
                
        return grid.items.filter({ $0 == "#" }).count
    }
    
    enum Instruction {
        case rect(Point)
        case rotateRow(Int, Int)
        case rotateCol(Int, Int)
    }
}

extension Day8 {
    func parse(_ input: String) -> Instruction {
        if input.hasPrefix("rect") {
            let values = input.replacingOccurrences(of: "rect ", with: "").split(separator: "x").map({ Int($0)! })
            return .rect(Point(values[0], values[1]))
        } else if input.hasPrefix("rotate row") {
            let values = input.replacingOccurrences(of: "rotate row y=", with: "").split(separator: " by ").map({ Int($0)! })
            return .rotateRow(values[0], values[1])
        } else {
            let values = input.replacingOccurrences(of: "rotate column x=", with: "").split(separator: " by ").map({ Int($0)! })
            return .rotateCol(values[0], values[1])
        }
    }
}
