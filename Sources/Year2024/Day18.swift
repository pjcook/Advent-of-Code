import Foundation
import StandardLibraries

public struct Day18 {
    public init() {}
        
    public func part1(_ input: [String], size: Int) -> Int {
        let points = parse(input)
        var grid = Grid<String>(size: Point(size, size), fill: ".")
        for p in points {
            grid[p] = "#"
        }
        
        return grid.dijkstra(start: Point(0, 0), end: grid.bottomRight - Point(1,1), maxPoint: grid.bottomRight, calculateScore: { _ in 1 }, canEnter: { point in
            return point.isValid(max: grid.bottomRight) && grid[point] != "#"
        })
    }
    
    public func part2(_ input: [String], size: Int) -> String {
        var grid = Grid<String>(size: Point(size, size), fill: ".")
        let points = parse(input)
        let start = input.count >= 1024 ? 1024 : 0
        if start != 0 {
            for p in points.prefix(start) {
                grid[p] = "#"
            }
        }
        
        for i in start..<points.count {
            grid[points[i]] = "#"
            if solve(grid) == -1 {
                return "\(points[i].x),\(points[i].y)"
            }
        }
        return "failed"
    }
    
    func solve(_ grid: Grid<String>) -> Int {
        return grid.dijkstra(start: Point(0, 0), end: grid.bottomRight - Point(1,1), maxPoint: grid.bottomRight, calculateScore: { _ in 1 }, canEnter: { point in
            return point.isValid(max: grid.bottomRight) && grid[point] != "#"
        })
    }
        
}

extension Day18 {
    func parse(_ input: [String]) -> [Point] {
        var points = [Point]()
        
        for line in input {
            let components = line.split(separator: ",").map { Int($0)! }
            points.append(Point(components[0], components[1]))
        }
        
        return points
    }
}
