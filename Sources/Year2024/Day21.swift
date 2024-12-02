import Foundation
import StandardLibraries

public struct Day21 {
    public init() {}
    
    public func part1(_ input: [String], steps: Int) -> Int {
        var grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        grid[start] = "."
        var queue = Set<Point>()
        queue.insert(start)
        for _ in (0..<steps) {
            var next = Set<Point>()
            while let point = queue.popFirst() {
                for neighbor in point.cardinalNeighbors(max: grid.bottomRight) {
                    if grid[neighbor] != "#" {
                        next.insert(neighbor)
                    }
                }
            }
            queue = next
        }
        
        return queue.count
    }
    
    public func part2(_ input: [String], steps: Int) -> Int {
        var grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        grid[start] = "."
        var queue = Set<Map>()
        queue.insert(Map(board: .zero, pointOnBoard: start))

        for _ in (0..<steps) {
            var next = Set<Map>()
            while let map = queue.popFirst() {
                for neighbor in map.pointOnBoard.cardinalNeighbors(true) {
                    var convertedPoint = neighbor
                    var board = map.board
                    
                    if convertedPoint.x < 0 {
                        board = board + Direction.left.point
                        convertedPoint = Point(grid.columns-1, convertedPoint.y)
                    } else if convertedPoint.x >= grid.columns {
                        board = board + Direction.right.point
                        convertedPoint = Point(0, convertedPoint.y)
                    } else if convertedPoint.y < 0 {
                        board = board + Direction.up.point
                        convertedPoint = Point(convertedPoint.x, grid.rows-1)
                    } else if convertedPoint.y >= grid.rows {
                        board = board + Direction.down.point
                        convertedPoint = Point(convertedPoint.x, 0)
                    }
                    
                    if grid[convertedPoint] != "#" {
                        next.insert(Map(board: board, pointOnBoard: convertedPoint))
                    }
                }
            }
            queue = next
        }
        
        return queue.count
    }
    
    public func part2b(_ input: [String], steps: Int) -> Int {
        var grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        grid[start] = "."
        let distances = findDistances(start: start, grid: grid)
        var result = 0
        
        var solveCache = [CacheKey: Int]()
        func solve(distance: Int, addition: Int, steps: Int) -> Int {
            let amount = (steps - distance) / grid.rows
            let cacheKey = CacheKey(distance: distance, addition: addition, steps: steps)
            if let cachedValue = solveCache[cacheKey] {
                return cachedValue
            }
            var result = 0
            
            for x in (1..<amount+1) {
                if distance + grid.rows * x <= steps && (distance + grid.rows * x) % 2 == steps % 2 {
                    result += (addition == 2 ? x + 1 : 1)
                }
            }
            
            solveCache[cacheKey] = result
            return result
        }
        
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let point = Point(x,y)
                let map = Map(board: .zero, pointOnBoard: point)
                if distances[map] != nil {
                    let options = [-3,-2,-1,0,1,2,3]
                    for ty in options {
                        for tx in options {
                            let distance = distances[Map(board: Point(tx,ty), pointOnBoard: point)]!
                            if distance % 2 == steps % 2 && distance <= steps {
                                result += 1
                            }
                            if [-3,3].contains(ty) && [-3,3].contains(tx) {
                                result += solve(distance: distance, addition: 2, steps: steps)
                            } else if [-3,3].contains(ty) || [-3,3].contains(tx) {
                                result += solve(distance: distance, addition: 1, steps: steps)
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    struct CacheKey: Hashable {
        let distance: Int
        let addition: Int
        let steps: Int
    }
    
    func findDistances(start: Point, grid: Grid<String>) -> [Map: Int] {
        var distances = [Map: Int]()
        var queue = [(Point,Point,Int)]()
        queue.append((.zero, start, 0))
        
        while !queue.isEmpty {
            var (board, point, distance) = queue.removeFirst()
            if point.x < 0 {
                board = board + Direction.left.point
                point = Point(grid.columns-1, point.y)
            } else if point.x >= grid.columns {
                board = board + Direction.right.point
                point = Point(0, point.y)
            } else if point.y < 0 {
                board = board + Direction.up.point
                point = Point(point.x, grid.rows-1)
            } else if point.y >= grid.rows {
                board = board + Direction.down.point
                point = Point(point.x, 0)
            }
            guard grid[point] != "#" else { continue }
            let map = Map(board: board, pointOnBoard: point)
            guard distances[map] == nil else { continue }
            guard abs(board.y) < 4 && abs(board.x) < 4 else { continue }
            distances[map] = distance
            for n in point.cardinalNeighbors(true) {
                queue.append((board, n, distance + 1))
            }
        }
        
        return distances
    }
    
    struct Map: Hashable {
        let board: Point
        let pointOnBoard: Point
    }
    
    enum Tiles: String {
        case start = "S"
        case plot = "."
        case rock = "#"
    }
}
