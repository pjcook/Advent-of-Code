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

public struct Day21 {
    public init() {}
    
    public func part1(_ input: [String], iterations: Int) -> Int {
        let rules = parse(input)
        var grid = """
.#.
..#
###
""".lines
        
        for _ in 0..<iterations {
            var nextGrid = [String]()
            let size = grid[0].count
            let dx = size % 2 == 0 ? 2 : 3
            
            for y in 0..<(size/dx) {
                var rows = Array(repeating: "", count: dx+1)
                for x in 0..<(size/dx) {
                    let point = Point(x, y)
                    var g = Grid()
                    for y in 0..<dx {
                        g.append(String(grid[point.y * dx + y][(point.x * dx)..<(point.x * dx + dx)]))
                    }
                    let cube = rules[g]!
                    for i in 0..<cube.count {
                        rows[i] += cube[i]
                    }
                }

                nextGrid.append(contentsOf: rows)
            }
            
            grid = nextGrid
//            print(i, (size/dx), grid.reduce(0) { $0 + $1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) } })
        }
        
        return grid.reduce(0) { $0 + $1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) } }
    }
    
    typealias Rules = [Grid : Grid]
    typealias Grid = [String]
}

extension Day21 {
    func parse(_ input: [String]) -> Rules {
        var results = [Grid: Grid]()
        
        for line in input {
            let parts = line.split(separator: " => ").map { $0.split(separator: "/").map(String.init) }
            results[parts[0]] = parts[1]
            results[parts[0].flipVertical().map({ $0 })] = parts[1]
            results[parts[0].flipHorizontal().map({ $0 })] = parts[1]
            results[parts[0].flipHorizontalAndVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft()] = parts[1]
            results[parts[0].rotateLeft().flipVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().flipHorizontal().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().flipHorizontalAndVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft()] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().flipVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().flipHorizontal().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().flipHorizontalAndVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().rotateLeft()] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().rotateLeft().flipVertical().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().rotateLeft().flipHorizontal().map({ $0 })] = parts[1]
            results[parts[0].rotateLeft().rotateLeft().rotateLeft().flipHorizontalAndVertical().map({ $0 })] = parts[1]
        }
        
        return results
    }
}
