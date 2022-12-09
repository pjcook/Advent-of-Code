//
//  File.swift
//  
//
//  Created by PJ on 09/12/2022.
//

import Foundation
import StandardLibraries

extension Day9 {
    func draw(points: Set<Point>, head: Point, tail1: Point, tail2: Point, tail3: Point, tail4: Point, tail5: Point, tail6: Point, tail7: Point, tail8: Point, tail9: Point) {
        var positions = points
        positions.insert(head)
        positions.insert(tail1)
        positions.insert(tail2)
        positions.insert(tail3)
        positions.insert(tail4)
        positions.insert(tail5)
        positions.insert(tail6)
        positions.insert(tail7)
        positions.insert(tail8)
        positions.insert(tail9)
        
        let (minCoord, maxCoord) = positions.minMax()
        
        for y in (minCoord.y...maxCoord.y) {
            var line = ""
            for x in (minCoord.x...maxCoord.x) {
                let point = Point(x, y)
                if points.contains(point) {
                    if point == .zero {
                        line.append("s")
                    } else {
                        line.append("#")
                    }
                    continue
                }
                
                switch point {
                case head: line.append("H")
                case tail1: line.append("1")
                case tail2: line.append("2")
                case tail3: line.append("3")
                case tail4: line.append("4")
                case tail5: line.append("5")
                case tail6: line.append("6")
                case tail7: line.append("7")
                case tail8: line.append("8")
                case tail9: line.append("9")
                default: line.append(".")
                }
            }
            print(line)
        }
        print()
    }
}
