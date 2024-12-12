import Foundation
import StandardLibraries

public class Day12 {
    public init() {}
    private var visited = Set<Point>()
    
    public func part1(_ input: [String]) -> Int {
        calculate(input, calculation: calculatePlotCost)
    }
    
    public func part2(_ input: [String]) -> Int {
        calculate(input, calculation: calculatePlotCostWithBulkDiscount)
    }
}

extension Day12 {
    func calculate(_ input: [String], calculation: (Point,Grid<String>) -> Int) -> Int {
        visited = []
        let grid = Grid<String>(input)
        var cost = 0
        
        for x in (0..<grid.columns) {
            for y in (0..<grid.rows) {
                let point = Point(x: x, y: y)
                guard !visited.contains(point) else { continue }
                
                cost += calculation(point, grid)
            }
        }
        
        return cost
    }
    
    func calculatePlotCost(for point: Point, in grid: Grid<String>) -> Int {
        let plotID = grid[point]
        var sides = 0
        var plots = 0
        var toVisit = [point]
        
        while !toVisit.isEmpty {
            let point = toVisit.removeFirst()
            plots += 1
            visited.insert(point)
            let neighbors = point.cardinalNeighbors(in: grid, matching: [plotID])
            
            sides += 4 - neighbors.count
            for n in neighbors {
                if !toVisit.contains(n), !visited.contains(n) {
                    toVisit.append(n)
                }
            }
        }
        
        return sides * plots
    }
    
    func calculatePlotCostWithBulkDiscount(for point: Point, in grid: Grid<String>) -> Int {
        let plotID = grid[point]
        var plots = [Point]()
        var toVisit = [point]
        
        // find all plots
        while !toVisit.isEmpty {
            let point = toVisit.removeFirst()
            plots.append(point)
            visited.insert(point)
            let neighbors = point.cardinalNeighbors(in: grid, matching: [plotID])
            
            for n in neighbors {
                if !toVisit.contains(n), !visited.contains(n) {
                    toVisit.append(n)
                }
            }
        }
        
        // calculate sides
        var sides = 0
        
        // calculate outer edge
        var position = point
        var direction: Direction = .right
        var remainingTiles = Set(plots)
        
        while !remainingTiles.isEmpty {
            let foundEdges = followEdge(from: position, with: direction, tiles: plots) {
                sides += 1
            }
            
            foundEdges.forEach { remainingTiles.remove($0) }
            for point in remainingTiles {
                let neighbors = point.cardinalNeighbors(in: grid, matching: [plotID])
                if neighbors.count == 4 {
                    remainingTiles.remove(point)
                }
            }
            
            if remainingTiles.isEmpty { continue }
            position = remainingTiles.first!
            let neighbors = position.cardinalNeighbors(in: grid, matching: [plotID])
            if !neighbors.contains(position + Direction.up.point) {
                direction = .right
            } else if !neighbors.contains(position + Direction.right.point) {
                direction = .down
            } else if !neighbors.contains(position + Direction.down.point) {
                direction = .left
            } else if !neighbors.contains(position + Direction.left.point) {
                direction = .up
            }
        }
        
        return sides * plots.count
    }
}
