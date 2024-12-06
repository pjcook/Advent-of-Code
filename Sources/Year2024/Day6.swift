import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    struct Place: Hashable {
        let point: Point
        let direction: CompassDirection
        
        func next(limit: Point) -> Point? {
            let nextPoint = point.add(direction: direction)
            if nextPoint.x < 0 || nextPoint.y < 0 || nextPoint.x >= limit.x || nextPoint.y >= limit.y {
                return nil
            }
            return nextPoint
        }
    }
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        let startIndex = grid.items.firstIndex(where: { $0 == "^" })!
        var currentPosition = Place(point: grid.point(for: startIndex), direction: .s)
        var visited = Set<Place>()
        
        while !visited.contains(currentPosition) {
            visited.insert(currentPosition)
            guard let point = currentPosition.next(limit: grid.bottomRight) else { break }
            if grid[point] == "#" {
                currentPosition = Place(point: currentPosition.point, direction: currentPosition.direction.rotateLeft())
            } else {
                currentPosition = Place(point: point, direction: currentPosition.direction)
            }
            
//            var points = Set<Point>()
//            visited.forEach { points.insert($0.point) }
//            draw(grid, points: Array(points))
        }
        
        var results = Set<Point>()
        visited.forEach { results.insert($0.point) }
        return results.count
    }
    
    func draw(_ grid: Grid<String>, points: [Point]) {
        var grid = grid
        for point in points {
            grid[point] = "X"
        }
        grid.draw()
        print()
    }
    
    public func part2(_ input: [String]) -> Int {
        var grid = Grid<String>(input)
        let startIndex = grid.items.firstIndex(where: { $0 == "^" })!
        let startPosition = Place(point: grid.point(for: startIndex), direction: .s)
        var currentPosition = startPosition
        var visited = Set<Place>()
        
        while !visited.contains(currentPosition) {
            visited.insert(currentPosition)
            guard let point = currentPosition.next(limit: grid.bottomRight) else { break }
            if grid[point] == "#" {
                currentPosition = Place(point: currentPosition.point, direction: currentPosition.direction.rotateLeft())
            } else {
                currentPosition = Place(point: point, direction: currentPosition.direction)
            }
        }
        
        var options = Set<Point>()
        visited.forEach { options.insert($0.point) }
        options.remove(startPosition.point)
        var results = 0
        
        for point in options {
            grid[point] = "#"
            results += hasInfiniteLoop(grid, start: startPosition) ? 1 : 0
            grid[point] = "."
        }
        
        return results
    }
    
    func hasInfiniteLoop(_ grid: Grid<String>, start: Place) -> Bool {
        var currentPosition = start
        var visited = Set<Place>()
        
        while !visited.contains(currentPosition) {
            visited.insert(currentPosition)
            guard let point = currentPosition.next(limit: grid.bottomRight) else { return false }
            if grid[point] == "#" {
                currentPosition = Place(point: currentPosition.point, direction: currentPosition.direction.rotateLeft())
            } else {
                currentPosition = Place(point: point, direction: currentPosition.direction)
            }
        }
        
        return true
    }
}
