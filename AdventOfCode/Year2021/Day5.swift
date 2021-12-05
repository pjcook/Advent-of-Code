import Foundation
import StandardLibraries

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [String], includeDiagonals: Bool = false) -> Int {
        let data = parse(input)
        let maxX = data.reduce(0) { max($0, $1.0.x, $1.1.x) }
        let maxY = data.reduce(0) { max($0, $1.0.y, $1.1.y) }
        var grid = Grid<Int>(columns: maxX, items: Array(repeating: 0, count: maxX + maxY * maxX))
        
        for item in data {
            if item.0.x == item.1.x {
                mapY(&grid, item)
            } else if item.0.y == item.1.y {
                mapX(&grid, item)
            } else if includeDiagonals {
                mapXY(&grid, item)
            }
        }

        return grid.items.reduce(0, { $0 + ($1 > 1 ? 1 : 0) })
    }
    
    public func mapX(_ grid: inout Grid<Int>, _ input: (Point,Point)) {
        let y = input.0.y
        for x in (min(input.0.x, input.1.x)...max(input.0.x, input.1.x)) {
            grid[x,y] = grid[x,y] + 1
        }
    }
    
    public func mapY(_ grid: inout Grid<Int>, _ input: (Point,Point)) {
        let x = input.0.x
        for y in (min(input.0.y, input.1.y)...max(input.0.y, input.1.y)) {
            grid[x,y] = grid[x,y] + 1
        }
    }
    
    public func mapXY(_ grid: inout Grid<Int>, _ input: (Point,Point)) {
        for i in (0...max(input.0.x, input.1.x)-min(input.0.x, input.1.x)) {
            let x = input.0.x < input.1.x ? input.0.x + i : input.0.x - i
            let y = input.0.y < input.1.y ? input.0.y + i : input.0.y - i
            grid[x,y] = grid[x,y] + 1
        }
    }
    
    public func parse(_ input: [String]) -> [(Point,Point)] {
        var data = [(Point,Point)]()
        for line in input {
            let a = line.components(separatedBy: " -> ")
            let p1 = a[0].components(separatedBy: ",")
            let p2 = a[1].components(separatedBy: ",")
            data.append(
                (
                    Point(Int(p1[0])!,Int(p1[1])!),
                    Point(Int(p2[0])!,Int(p2[1])!)
                )
            )
        }
        return data
    }
}
