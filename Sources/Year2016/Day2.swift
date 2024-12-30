//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import InputReader
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: [String]) -> String {
        let grid = Grid<Int>(columns: 3, items: [1,2,3,4,5,6,7,8,9])
        var point = Point(1,1)
        var results = [Int]()
        
        for line in input {
            for char in line {
                var next = point
                switch char {
                case "U": next.y -= 1
                case "D": next.y += 1
                case "L": next.x -= 1
                case "R": next.x += 1
                default: continue
                }
                if next.isValid(max: grid.bottomRight) {
                    point = next
                }
            }
            results.append(grid[point])
        }
        
        return results.map(String.init).joined()
    }
    
    public func part2(_ input: [String]) -> String {
        let keypad = """
XX1XX
X234X
56789
XABCX
XXDXX
""".lines
        let grid = Grid<String>(keypad)
        var point = Point(1,1)
        var results = [String]()
        
        for line in input {
            for char in line {
                var next = point
                switch char {
                case "U": next.y -= 1
                case "D": next.y += 1
                case "L": next.x -= 1
                case "R": next.x += 1
                default: continue
                }
                if next.isValid(max: grid.bottomRight) && grid[next] != "X" {
                    point = next
                }
            }
            results.append(grid[point])
        }
        
        return results.reduce("") { $0 + $1 }
    }
}
