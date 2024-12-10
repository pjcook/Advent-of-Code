import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        let startPositions = grid.points(for: 0)
        var results = 0
        
        for startPosition in startPositions {
            let points = Set(checkPath(startPosition, current: 0, grid: grid))
            results += points.count
        }

        return results
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        let startPositions = grid.points(for: 0)
        var results = 0
        
        for startPosition in startPositions {
            let points = checkPath(startPosition, current: 0, grid: grid)
            results += points.count
        }

        return results
    }
}

extension Day10 {
    func checkPath(_ point: Point, current: Int, grid: Grid<Int>) -> [Point] {
        let neighbours = point.cardinalNeighbors(max: grid.bottomRight)
        var results = [Point]()
        
        for neighbour in neighbours {
            let value = grid[neighbour]
            guard value == current + 1 else { continue }
            if value == 9 {
                results.append(neighbour)
            } else {
                results += checkPath(neighbour, current: value, grid: grid)
            }
        }
        
        return results
    }
}
