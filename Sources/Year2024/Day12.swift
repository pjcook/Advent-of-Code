import Foundation
import StandardLibraries

public class Day12 {
    public init() {}
    private var visited = Set<Point>()
    
    public func part1(_ input: [String]) -> Int {
        visited = []
        let grid = Grid<String>(input)
        var cost = 0
        
        for x in (0..<grid.columns) {
            for y in (0..<grid.rows) {
                let point = Point(x: x, y: y)
                guard !visited.contains(point) else { continue }
                
                cost += calculatePlotCost(for: point, in: grid)
            }
        }
        
        return cost
    }
    
    public func part2(_ input: [String]) -> Int {
        visited = []
        let grid = Grid<String>(input)
        var cost = 0
        
        for x in (0..<grid.columns) {
            for y in (0..<grid.rows) {
                let point = Point(x: x, y: y)
                guard !visited.contains(point) else { continue }
                
                cost += calculatePlotCostWithBulkDiscount(for: point, in: grid)
            }
        }
        
        return cost
    }
}

extension Day12 {
    func calculatePlotCost(for point: Point, in grid: Grid<String>) -> Int {
        let plotID = grid[point]
        var sides = 0
        var plots = 0
        var toVisit = [point]
        
        while !toVisit.isEmpty {
            let point = toVisit.removeFirst()
            plots += 1
            visited.insert(point)
            let neighbors = findValidNeighbours(for: point, grid: grid, plotID: plotID)
            
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
            let neighbors = findValidNeighbours(for: point, grid: grid, plotID: plotID)
            
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
            let (foundSides, foundEdges) = followEdge(from: position, with: direction, plots: plots)
            sides += foundSides
            
            foundEdges.forEach { remainingTiles.remove($0) }
            for point in remainingTiles {
                let neighbors = findValidNeighbours(for: point, grid: grid, plotID: plotID)
                if neighbors.count == 4 {
                    remainingTiles.remove(point)
                }
            }
            
            if remainingTiles.isEmpty { continue }
            position = remainingTiles.first!
            let neighbors = findValidNeighbours(for: position, grid: grid, plotID: plotID)
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
    
    func findValidNeighbours(for point: Point, grid: Grid<String>, plotID: String) -> Set<Point> {
        var neighbors = point.cardinalNeighbors(max: grid.bottomRight)
        for n in neighbors {
            if grid[n] != plotID {
                neighbors.remove(n)
            }
        }
        return neighbors
    }
    
    func followEdge(from point: Point, with initialDirection: Direction, plots: [Point]) -> (Int, Set<Point>) {
        var sides = 0
        var position = point
        var direction: Direction = initialDirection
        var edges = Set<Point>()
        while true {
            edges.insert(position)
            if canContinue(from: position, in: direction, plots: plots) {
                position = position + direction.point
                
                // Exit when back at start
                if position == point, direction == initialDirection {
                    break
                }
                continue
            }
            
            sides += 1
            changeDirection(from: &position, in: &direction, plots: plots)
            
            // Exit when back at start
            if position == point, direction == initialDirection {
                break
            }
        }
        
        return (sides, edges)
    }
    
    func canContinue(from point: Point, in direction: Direction, plots: [Point]) -> Bool {
        let next = point + direction.point
        return plots.contains(next) && !plots.contains(next + direction.emptyEdge.point)
    }
    
    func changeDirection(from point: inout Point, in direction: inout Direction, plots: [Point]) {
        var next = point + direction.point
        
        if plots.contains(next + direction.emptyEdge.point) {
            point = next + direction.emptyEdge.point
            direction = direction.emptyEdge
        } else {
            direction = direction.emptyEdge.opposite
        }
    }
}

extension Direction {
    var emptyEdge: Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }
}
