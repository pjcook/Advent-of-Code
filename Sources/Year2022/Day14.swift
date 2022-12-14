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
    
    let air = "."
    let wall = "#"
    let sand = "o"
    let start = "+"
    
    public func part1(_ input: [String]) -> Int {
        let data = parse(input)
        var allPoints = [Point]()
        
        for points in data {
            for i in (1..<points.count) {
                let point1 = points[i-1]
                let point2 = points[i]
                if point1.x == point2.x {
                    for y in (min(point1.y, point2.y)...max(point2.y, point1.y)) {
                        allPoints.append(Point(point1.x, y))
                    }
                } else {
                    for x in (min(point1.x, point2.x)...max(point2.x, point1.x)) {
                        allPoints.append(Point(x, point1.y))
                    }
                }
            }
        }
        
        let minMax = allPoints.minMax()
        let maxLeft = Point(minMax.0.x-1, minMax.1.y)
        var grid = Grid(columns: minMax.1.x + 1, items: Array(repeating: air, count: (minMax.1.x + 1) * (minMax.1.y + 1)))
        
        for point in allPoints {
            grid[point] = wall
        }
        
        let startPoint = Point(500, 0)
    outerloop: while true {
            var point = startPoint
            while true {
                let downPoint = point + Position.b.point
                guard downPoint != maxLeft else { break outerloop }
                let down = grid[downPoint]
                if down == air {
                    point = downPoint
                    continue
                }

                let leftPoint = point + Position.bl.point
                guard leftPoint != maxLeft else { break outerloop }
                let left = grid[leftPoint]
                if left == air {
                    point = leftPoint
                    continue
                }

                let rightPoint = point + Position.br.point
                guard rightPoint != maxLeft else { break outerloop }
                let right = grid[rightPoint]
                if right == air {
                    point = rightPoint
                    continue
                }
                
                grid[point] = sand
                break
            }
        }
        
//        grid.draw()
        
        return grid.items.reduce(0, { $0 + ($1 == sand ? 1 : 0) })
    }
    
    public func part2(_ input: [String]) -> Int {
        let data = parse(input)
        var allPoints = [Point]()
        
        for points in data {
            for i in (1..<points.count) {
                let point1 = points[i-1]
                let point2 = points[i]
                if point1.x == point2.x {
                    for y in (min(point1.y, point2.y)...max(point2.y, point1.y)) {
                        allPoints.append(Point(point1.x, y))
                    }
                } else {
                    for x in (min(point1.x, point2.x)...max(point2.x, point1.x)) {
                        allPoints.append(Point(x, point1.y))
                    }
                }
            }
        }
        
        let minMax = allPoints.minMax()
        let rows = minMax.1.y + 2
        let columns = minMax.1.x * 2
        var grid = Grid(columns: columns, items: Array(repeating: air, count: (columns + 1) * (rows + 1)))
        
        for point in allPoints {
            grid[point] = wall
        }
        
        // add floor
        for x in (0..<columns) {
            grid[Point(x, rows)] = wall
        }
        
        let startPoint = Point(500, 0)
    outerloop: while true {
            var point = startPoint
            guard grid[point] != sand else { break }
            while true {
                let downPoint = point + Position.b.point
                let down = grid[downPoint]
                if down == air {
                    point = downPoint
                    continue
                }

                let leftPoint = point + Position.bl.point
                let left = grid[leftPoint]
                if left == air {
                    point = leftPoint
                    continue
                }

                let rightPoint = point + Position.br.point
                let right = grid[rightPoint]
                if right == air {
                    point = rightPoint
                    continue
                }
                
                grid[point] = sand
                break
            }
        }
        
//        grid.draw()
        
        return grid.items.reduce(0, { $0 + ($1 == sand ? 1 : 0) })
    }
}

extension Day14 {
    public func parse(_ input: [String]) -> [[Point]] {
        var results = [[Point]]()
        
        for line in input {
            let points = line.components(separatedBy: " -> ").map {
                let components = $0.components(separatedBy: ",")
                return Point(Int(components[0])!, Int(components[1])!)
            }
            results.append(points)
        }
        
        return results
    }
}
