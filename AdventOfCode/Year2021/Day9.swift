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
                let n = point.cardinalNeighbors(max: max)
                let values = n.map {
                    grid[$0.x, $0.y]
                }.sorted()
                let value = grid[point.x, point.y]
                if value < values.first! {
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
                let n = point.cardinalNeighbors(max: max)
                let values = n.map {
                    grid[$0.x, $0.y]
                }.sorted()
                let value = grid[point.x, point.y]
                if value < values.first! {
                    // low point, calculate basin
                    var points = [point:value]
                    findBasin(point, grid: grid, points: &points)
                    basin.append(points.reduce(0, { $0 + ($1.value != -1 ? 1 : 0) }))
                    
                }
            }
        }
        
        let sortedBasins = Array(basin.sorted().reversed())
        var count = 1
        for i in (0..<3) {
            count *= sortedBasins[i]
        }
        return count
    }
    
    public func findBasin(_ point: Point, grid: Grid<Int>, points: inout [Point:Int]) {
        let max = Point(grid.columns, grid.rows)
        let n = point.cardinalNeighbors(max: max)
        
        var n2 = [Point]()
        for p in n {
            let value = grid[p.x, p.y]
            if points[p] == nil {
                if value == 9 {
                    points[p] = -1
                } else {
                    points[p] = value
                    n2.append(p)
                }
            }
        }
        
        for p in n2 {
            findBasin(p, grid: grid, points: &points)
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
