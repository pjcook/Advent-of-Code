import Foundation
import StandardLibraries

public struct Day18 {
    public init() {}
    
    public func part1(_ input: [String], steps: Int = 100) -> Int {
        var grid = parse(input)
        for _ in (0..<steps) {
            grid = step(grid)
        }
        return grid.items.reduce(0, { $0 + ($1 ? 1 : 0) })
    }
    
    public func part2(_ input: [String], steps: Int = 100) -> Int {
        var grid = parse(input)
        grid = forceCornersOn(grid)
        for _ in (0..<steps) {
            grid = step(grid)
            grid = forceCornersOn(grid)
        }
        return grid.items.reduce(0, { $0 + ($1 ? 1 : 0) })
    }
    
    public func forceCornersOn(_ grid: Grid<Bool>) -> Grid<Bool> {
        var newGrid = grid
        newGrid[0,0] = true
        newGrid[0,grid.columns-1] = true
        newGrid[grid.rows-1,0] = true
        newGrid[grid.rows-1,grid.columns-1] = true
        return newGrid
    }
    
    public func step(_ grid: Grid<Bool>) -> Grid<Bool> {
        var newGrid = grid
        let max = Point(grid.columns, grid.rows)
        for x in (0..<grid.columns) {
            for y in (0..<grid.rows) {
                let point = Point(x,y)
                let count = point.neighbors(max: max).reduce(0, { $0 + (grid[$1] ? 1 : 0) })
                let current = grid[point]
                if current && ![2,3].contains(count) {
                    newGrid[point] = false
                } else if !current && count == 3 {
                    newGrid[point] = true
                }
            }
        }
        return newGrid
    }
    
    public func parse(_ input: [String]) -> Grid<Bool> {
        var items = [Bool]()
        
        for line in input {
            for c in line {
                items.append(c == "#")
            }
        }
        
        return Grid(columns: input[0].count, items: items)
    }
}
