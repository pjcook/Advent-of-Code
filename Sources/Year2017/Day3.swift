//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public func part1(_ input: Int) -> Int {
        // l*4+4+sum(n-1...)
        var count = 1
        var i = 1
        var length = 1
        while true {
            if count + length * 4 + 4 < input {
                count += length * 4 + 4
                length += 2
                i += 1
            } else {
                break
            }
        }
        
        var point = Point(i, i-1)
        length += 2
        i = 1
        count += 1
        var direction = Direction.up
        while count != input {
            point = point + direction.point
            count += 1
            i += 1
            if i == length-1 {
                direction = direction.rotateLeft()
                i = 0
            }
        }
        
        print(point)
        return point.manhattanDistance(to: .zero)
    }
    
    public func part2(_ input: Int) -> Int {
        var points = [Point.zero: 1]
        var i = 1
        var length = 3
        var point = Point(1,0)
        var direction = Direction.up
        
        while true {
            points[point] = point.neighbors(true).reduce(0) {
                $0 + points[$1, default: 0]
            }
            print(points[point]!, point.x, point.y, length, i)
            if points[point]! > input {
                return points[point]!
            }
            point = point + direction.point
            i += 1
            if (i == length - 1 && direction != .right) || (direction == .right && i == length) {
                direction = direction.rotateLeft()
                i = 0
                if direction == .up {
                    length += 2
                    i += 1
                }
            }
        }
        
        return -1
    }
}
