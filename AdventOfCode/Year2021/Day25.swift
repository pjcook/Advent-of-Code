import Foundation
import StandardLibraries

public struct Day25 {
    public init() {}
    
    public enum Tile: Hashable {
        case e
        case s
        case free
    }
    
    public func part1(_ input: [String]) -> Int {
        var grid = parse(input)
        var i = 0
//        draw(grid, title: "Initial state:")
        while true {
            let next = move(grid)
            i += 1
//            draw(next, title: "After \(i) steps:")
            if next.items == grid.items {
                break
            }
            grid = next
        }
        
        return i
    }
    
    public func part2(_ input: [String]) -> Int {
        return 0
    }
    
    public func draw(_ grid: Grid<Tile>, title: String?) {
        if let title = title {
            print(title)
        }
        for y in (0..<grid.rows) {
            var row = ""
            for x in (0..<grid.columns) {
                switch grid[x,y] {
                case .free: row.append(".")
                case .e: row.append(">")
                case .s: row.append("v")
                }
            }
            print(row)
        }
        print()
    }
    
    public func move(_ oldGrid: Grid<Tile>) -> Grid<Tile> {
        var grid = oldGrid
        var movedPoints = Set<Point>()
        // Move East
        let moveEast = Point(1,0)
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let point = Point(x,y)
                if grid[point] != .e || movedPoints.contains(point) { continue }
                var next = point + moveEast
                if next.x >= grid.columns {
                    next.x = 0
                }
                if oldGrid[next] == .free {
                    grid[next] = grid[point]
                    grid[point] = .free
                    movedPoints.insert(next)
                }
            }
        }
        let eastGrid = grid
        
        // Move South
        let moveSouth = Point(0,1)
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let point = Point(x,y)
                if grid[point] != .s || movedPoints.contains(point) { continue }
                var next = point + moveSouth
                if next.y >= grid.rows {
                    next.y = 0
                }
                if eastGrid[next] == .free {
                    grid[next] = grid[point]
                    grid[point] = .free
                    movedPoints.insert(next)
                }
            }
        }
        return grid
    }
    
    public func parse(_ input: [String]) -> Grid<Tile> {
        var tiles = [Tile]()
        
        for row in input {
            for c in row {
                switch c {
                case ".": tiles.append(.free)
                case ">": tiles.append(.e)
                case "v": tiles.append(.s)
                default: abort()
                }
            }
        }
        
        return Grid(columns: input[0].count, items: tiles)
    }
}
