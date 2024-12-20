import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String], savingAtLeast: Int) -> Int {
        let grid = Grid<String>(input)
        let start = grid.point(for: "S")!
        let end = grid.point(for: "E")!
        var result = 0
        
        let (shortestPath, costSoFar) = grid.dijkstraPath(start: start, end: end) { _ in
            1
        } canEnter: { point in
            grid[point] != "#"
        }
        let shortestRouteCost = costSoFar[end]!

        for point in shortestPath {
            let neighbors = point.cardinalNeighbors(min: Point(1,1), max: grid.bottomRight - Point(1,1))
            for neighbor in neighbors {
                let neighbor2 = neighbor + neighbor - point
                if neighbor2.isValid(max: grid.bottomRight), grid[neighbor] == "#", grid[neighbor2] == "." {
                    let a = shortestPath.firstIndex(of: point)!
                    let b = shortestPath.count - shortestPath.firstIndex(of: neighbor2)!
                    let cost = a + b
                    
                    if cost <= shortestRouteCost-savingAtLeast {
                        result += 1
                    }
                }
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String], savingAtLeast: Int) -> Int {
        let grid = Grid<String>(input)
        let start = grid.point(for: "S")!
        let end = grid.point(for: "E")!
        var result = 0
        
        let (shortestPath, costSoFar) = grid.dijkstraPath(start: start, end: end) { _ in
            1
        } canEnter: { point in
            grid[point] != "#"
        }
        let shortestRouteCost = costSoFar[end]!
        let targetCost = shortestRouteCost - savingAtLeast
        var cost = [Point: Int]()
        for point in shortestPath {
            cost[point] = shortestRouteCost - costSoFar[point]!
        }
        
        var extremeNeighbors = [Point]()
        for x in (-20...20) {
            for y in (-20...20) {
                let point = Point(x,y)
                if point != .zero, point.manhattanDistance(to: .zero) <= 20 {
                    extremeNeighbors.append(point)
                }
            }
        }

        for i in (0..<shortestPath.count) {
            let point = shortestPath[i]
            let neighbors = extremeNeighbors.compactMap { p in
                let next = point + p
                if next.isValid(max: grid.bottomRight), grid[next] != "#" {
                    return next
                } else {
                    return nil
                }
            }
            for neighbor in neighbors {
                let b = cost[neighbor]!
                let cost = i + b + point.manhattanDistance(to: neighbor)
                
                if cost <= targetCost {
                    result += 1
                }
            }
        }
        
        return result
    }
}
