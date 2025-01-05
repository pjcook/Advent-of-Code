//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public func part1(_ input: [String]) -> String {
        let size = Point(input.reduce(0, { max($0, $1.count + 1) }), input.count)
        let grid = Grid<String>(input, size: size)
        var point = grid.point(for: (0..<grid.columns).first(where: { grid[Point($0, 0)] == "|" })!)
        var direction = Direction.down
        var output = ""
        
        mainLoop: while true {
            switch (grid[point], direction) {
            case ("|", _), ("-", _):
                break

            case ("+", _):
                switch direction {
                case .up:
                    if ![" ", "|"].contains(grid[point.left()]) {
                        direction = direction.rotateLeft()
                    } else if ![" ", "|"].contains(grid[point.right()]) {
                        direction = direction.rotateRight()
                    } else {
                        break mainLoop
                    }
                    
                case .down:
                    if ![" ", "|"].contains(grid[point.left()]) {
                        direction = direction.rotateRight()
                    } else if ![" ", "|"].contains(grid[point.right()]) {
                        direction = direction.rotateLeft()
                    } else {
                        break mainLoop
                    }
                case .left:
                    if ![" ", "-"].contains(grid[point.up()]) {
                        direction = direction.rotateRight()
                    } else if ![" ", "-"].contains(grid[point.down()]) {
                        direction = direction.rotateLeft()
                    } else {
                        break mainLoop
                    }
                    
                case .right:
                    if ![" ", "-"].contains(grid[point.up()]) {
                        direction = direction.rotateLeft()
                    } else if ![" ", "-"].contains(grid[point.down()]) {
                        direction = direction.rotateRight()
                    } else {
                        break mainLoop
                    }
                }

            case (" ", _):
                break mainLoop

            default:
                output += grid[point]
            }
            point = point + direction.point
        }

        return output
    }
    
    public func part2(_ input: [String]) -> Int {
        let size = Point(input.reduce(0, { max($0, $1.count + 1) }), input.count)
        let grid = Grid<String>(input, size: size)
        var point = grid.point(for: (0..<grid.columns).first(where: { grid[Point($0, 0)] == "|" })!)
        var direction = Direction.down
        var count = 0
        
        mainLoop: while true {
            switch (grid[point], direction) {
            case ("|", _), ("-", _):
                break

            case ("+", _):
                switch direction {
                case .up:
                    if ![" ", "|"].contains(grid[point.left()]) {
                        direction = direction.rotateLeft()
                    } else if ![" ", "|"].contains(grid[point.right()]) {
                        direction = direction.rotateRight()
                    } else {
                        break mainLoop
                    }
                    
                case .down:
                    if ![" ", "|"].contains(grid[point.left()]) {
                        direction = direction.rotateRight()
                    } else if ![" ", "|"].contains(grid[point.right()]) {
                        direction = direction.rotateLeft()
                    } else {
                        break mainLoop
                    }
                case .left:
                    if ![" ", "-"].contains(grid[point.up()]) {
                        direction = direction.rotateRight()
                    } else if ![" ", "-"].contains(grid[point.down()]) {
                        direction = direction.rotateLeft()
                    } else {
                        break mainLoop
                    }
                    
                case .right:
                    if ![" ", "-"].contains(grid[point.up()]) {
                        direction = direction.rotateLeft()
                    } else if ![" ", "-"].contains(grid[point.down()]) {
                        direction = direction.rotateRight()
                    } else {
                        break mainLoop
                    }
                }

            case (" ", _):
                break mainLoop

            default:
                break
            }
            point = point + direction.point
            count += 1
        }

        return count
    }
}
