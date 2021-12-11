import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    public func part1(_ input: [String], steps: Int = 100) -> Int {
        var grid = parse(input)
        var count = 0
        let max = Point(grid.columns, grid.rows)
//        grid.draw()
//        print()
        for _ in (0..<steps) {
            var requiresFlash = [Point]()
            for i in (0..<grid.items.count) {
                let point = Point(i / grid.columns, i % grid.columns)
                let value = grid[point]
                if value == 9 {
                    requiresFlash.append(point)
                    grid[point] = 0
                } else {
                    grid[point] = value + 1
                }
            }
            
            for point in requiresFlash {
                flash(point, grid: &grid, count: &count, max: max)
            }
//
//            grid.draw()
//            print()
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        var grid = parse(input)
        var count = 0
        let max = Point(grid.columns, grid.rows)
        var allFlashed = false
        var step = 0
//        grid.draw()
//        print()
        
        while !allFlashed {
            var requiresFlash = [Point]()
            for i in (0..<grid.items.count) {
                let point = Point(i / grid.columns, i % grid.columns)
                let value = grid[point]
                if value == 9 {
                    requiresFlash.append(point)
                    grid[point] = 0
                } else {
                    grid[point] = value + 1
                }
            }
            
            for point in requiresFlash {
                flash(point, grid: &grid, count: &count, max: max)
            }
            
//            grid.draw()
//            print()
            step += 1
            allFlashed = grid.items.reduce(0, +) == 0
        }
        
        return step
    }
    
    public func step(grid: inout Grid<Int>, count: inout Int, max: Point) {
        var requiresFlash = [Point]()
        for i in (0..<grid.items.count) {
            let point = Point(i / grid.columns, i % grid.columns)
            let value = grid[point]
            if value == 9 {
                requiresFlash.append(point)
                grid[point] = 0
            } else {
                grid[point] = value + 1
            }
        }
        
        for point in requiresFlash {
            flash(point, grid: &grid, count: &count, max: max)
        }
    }
    
    public func flash(_ point: Point, grid: inout Grid<Int>, count: inout Int, max: Point) {
        count += 1
        grid[point] = 0
        let neighbours = point.neighbors(false, max: max)
        
        for p in neighbours {
            let value = grid[p]
            if value == 0 {
                continue
            } else if value == 9 {
                flash(p, grid: &grid, count: &count, max: max)
            } else {
                grid[p] = value + 1
            }
        }
    }
    
    public func parse(_ input: [String]) -> Grid<Int> {
        var items = [Int]()
        
        for line in input {
            line.forEach { items.append(Int(String($0))!) }
        }
        
        return Grid(columns: 10, items: items)
    }
}
