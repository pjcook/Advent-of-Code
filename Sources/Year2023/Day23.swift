import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        let start = Point(1, 0)
        let end = Point(grid.columns - 2, grid.rows - 1)
        var nodes = [Point: [Point: Int]]()
        var visited = Set<Point>()
        var queue = [start]
        while !queue.isEmpty {
            let point = queue.removeFirst()
            guard !visited.contains(point) else { continue }
            visited.insert(point)
            for next in point.cardinalNeighbors(max: grid.bottomRight) where grid[next] != "#" {
                let (p, d) = findNextTarget(start: [point, next], grid: grid)
                if !visited.contains(p) {
                    var options = nodes[point, default: [Point: Int]()]
                    options[p] = d
                    nodes[point] = options
                    queue.append(p)
                }
            }
        }
        
        var queue2 = [[start]]
        var longestPath = 0
        while !queue2.isEmpty {
            let history = queue2.removeLast()
            let point = history.last!
            for next in nodes[point]! { //.filter({ $0.key.origin == point && !history.contains($0.key.target) }) {
                guard !history.contains(next.key) else { continue }
                var trail = history
                trail.append(next.key)
                if next.key == end {
                    longestPath = max(longestPath, calculateDistance(trail: trail, nodes: nodes))
                    continue
                }
                queue2.append(trail)
            }
        }
        
        return longestPath
    }
    
    // Hamiltonian path problem
    public func part2(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        let start = Point(1, 0)
        let end = Point(grid.columns - 2, grid.rows - 1)
        var nodes = [Point: [Point: Int]]()
        var visited = Set<Point>()
        var queue = [start]
        let startTime = Date()
        print(abs(startTime.timeIntervalSinceNow))
        while !queue.isEmpty {
            let point = queue.removeFirst()
            guard !visited.contains(point) else { continue }
            visited.insert(point)
            for next in point.cardinalNeighbors(max: grid.bottomRight) where grid[next] != "#" {
                let (p, d) = findNextTarget(start: [point, next], grid: grid)
                if !visited.contains(p) {
                    var options = nodes[point, default: [Point: Int]()]
                    options[p] = d
                    nodes[point] = options
                    queue.append(p)
                    
                    var options2 = nodes[p, default: [Point: Int]()]
                    options2[point] = d
                    nodes[p] = options2
                }
            }
        }
        print(abs(startTime.timeIntervalSinceNow))
        var queue2 = [([start], 0)]
        var longestPath = 0
        while !queue2.isEmpty {
            let (history, distance) = queue2.removeLast()
            let point = history.last!
            for next in nodes[point]! where !history.contains(next.key) {
                var trail = history
                trail.append(next.key)
                if next.key == end {
                    longestPath = max(longestPath, distance + next.value)
                    continue
                }
                queue2.append((trail, distance + next.value))
            }
        }
        print(abs(startTime.timeIntervalSinceNow))
        return longestPath
    }
    
    func calculateDistance(trail: [Point], nodes: [Point: [Point: Int]]) -> Int {
        var distance = 0
        
        for i in (1..<trail.count) {
            let origin = trail[i-1]
            let target = trail[i]
            distance += nodes[origin]![target]!
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
