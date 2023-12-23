import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var seen = [Point: Int]()
        var queue = [[Point]]()
        queue.append([Point(1, 0)])
        let end = Point(grid.columns - 2, grid.rows - 1)
        var longestRoute = 0
        
        while !queue.isEmpty {
            let history = queue.removeFirst()
            let point = history.last!
            
            for direction in Direction.allCases {
                let next = point + direction.point
                guard
                    next.isValid(max: grid.bottomRight),
                    [".", direction.slope].contains(grid[next]),
                    !history.contains(next) else { continue }
                if next == end {
                    longestRoute = max(history.count, longestRoute)
                    continue
                }
                var trail = history
                trail.append(next)
                let prev = seen[next, default: 0]
                if prev < trail.count {
                    seen[next] = trail.count
                    queue.append(trail)
                }
            }
        }
        
        return longestRoute
    }
    
    struct Node: Hashable {
        let origin: Point
        let target: Point
    }
    
    // Hamiltonian path problem
    public func part2(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        let start = Point(1, 0)
        let end = Point(grid.columns - 2, grid.rows - 1)
        var nodes = [Node: Int]()
        var visited = Set<Point>()
        var queue = [start]
        while !queue.isEmpty {
            let point = queue.removeFirst()
            guard !visited.contains(point) else { continue }
            visited.insert(point)
            for next in point.cardinalNeighbors(max: grid.bottomRight) where grid[next] != "#" {
                let (p, d) = findNextTarget(start: [point, next], grid: grid)
                if !visited.contains(p) {
                    nodes[Node(origin: point, target: p)] = d
                    nodes[Node(origin: p, target: point)] = d
                    queue.append(p)
                }
            }
        }
        
        var queue2 = [[start]]
        var longestPath = 0
        while !queue2.isEmpty {
            let history = queue2.removeLast()
            let point = history.last!
            for next in nodes.filter({ $0.key.origin == point && !history.contains($0.key.target) }) {
                var trail = history
                trail.append(next.key.target)
                if next.key.target == end {
                    longestPath = max(longestPath, calculateDistance(trail: trail, nodes: nodes))
                    continue
                }
                queue2.append(trail)
            }
        }
        
        return longestPath
    }
    
    func calculateDistance(trail: [Point], nodes: [Node: Int]) -> Int {
        var distance = 0
        
        for i in (1..<trail.count) {
            let prev = trail[i-1]
            let cur = trail[i]
            distance += nodes[Node(origin: prev, target: cur)]!
        }
        
        return distance
    }
    
    func findNextTarget(start: [Point], grid: Grid<String>) -> (Point, Int) {
        var history = start
        var prev = start[0]
        var next = start[1]

        while true {
            var neighbors = next.cardinalNeighbors(max: grid.bottomRight).filter {
                $0 != prev && grid[$0] != "#"
            }
            
            if neighbors.count == 1 {
                prev = next
                next = neighbors.first!
                history.append(next)
            } else {
                break
            }
        }
        
        return (history.last!, history.count - 1)
    }
    
    enum Tiles: String {
        case path = "."
        case forest = "#"
        case slopeN = "^"
        case slopeE = ">"
        case slopeS = "v"
        case slopeW = "<"
    }
}

extension Direction {
    var slope: String {
        switch self {
        case .left: "<"
        case .down: "v"
        case .right: ">"
        case .up: "^"
        }
    }
}
