import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = parse(input)
        var count = 0
        let max = Point(grid.columns, grid.rows)
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let point = Point(x,y)
                let value = grid[point.x, point.y]
                if isLowPoint(point, value: value, grid: grid, max: max) {
                    count += value + 1
                }
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        var basin = [Int]()
        let max = Point(grid.columns, grid.rows)
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let point = Point(x,y)
                let value = grid[point.x, point.y]
                if isLowPoint(point, value: value, grid: grid, max: max) {
                    basin.append(calculateBasin(point, grid: grid, max: max))
                }
            }
        }
        
        return basin
            .sorted()
            .dropFirst(basin.count - 3)
            .reduce(1, *)
    }
    
    public func isLowPoint(_ point: Point, value: Int, grid: Grid<Int>, max: Point) -> Bool {
        guard value < 9 else { return false }
        let n = point.cardinalNeighbors(max: max)
        let values = n.map {
            grid[$0.x, $0.y]
        }.sorted()
        return value < values.first!
    }
    
    public func calculateBasin(_ point: Point, grid: Grid<Int>, max: Point) -> Int {
        var points = [point:1]
        findBasin(point, grid: grid, max: max, points: &points)
        return points.reduce(0, { $0 + $1.value })
    }
    
    public func findBasin(_ point: Point, grid: Grid<Int>, max: Point, points: inout [Point:Int]) {
        let n = point.cardinalNeighbors(max: max)
        
        var n2 = [Point]()
        for p in n {
            let value = grid[p.x, p.y]
            if points[p] == nil {
                if value == 9 {
                    points[p] = 0
                } else {
                    points[p] = 1
                    n2.append(p)
                }
            }
        }
        
        for p in n2 {
            findBasin(p, grid: grid, max: max, points: &points)
        }
    }
    
    public func parse(_ input: [String]) -> Grid<Int> {
        var items = [Int]()
        
        for row in input {
            _ = row.map {
                items.append(Int(String($0))!)
            }
        }
        
        return Grid(columns: input[0].count, items: items)
    }
}
