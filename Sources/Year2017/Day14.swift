//
//
//  File.swift
//
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        var count = 0
        
        for i in 0...127 {
            let key = input + "-" + String(i)
            let knot = key.knotHash()
            let binary = knot.map(String.init).compactMap({ Int($0, radix: 16)?.binary })
            count += binary.reduce(0) { $0 + $1.reduce(0) { $0 + Int(String($1))! } }
        }
        
        return count
    }
    
    public func part2(_ input: String) -> Int {
        var grid = Grid<String>(size: Point(128, 128), fill: ".")
        
        for y in 0...127 {
            let key = input + "-" + String(y)
            let knot = key.knotHash()
            let binary = knot.map(String.init).compactMap({ Int($0, radix: 16)?.binary(padLength: 4) }).joined()
            for x in 0...127 {
                grid[Point(x,y)] = String(binary[x])
            }
        }
        
        var points: Set<Point> = Set(grid.points(for: "1"))
        var regions = 0
        
        while points.isEmpty == false {
            var queue = [points.removeFirst()]
            while queue.isEmpty == false && points.isEmpty == false {
                let point = queue.removeFirst()
                for p in point.cardinalNeighbors(max: grid.bottomRight) {
                    if points.contains(p) {
                        points.remove(p)
                        queue.append(p)
                    }
                }
            }
            regions += 1
        }
        
        return regions
    }
}
