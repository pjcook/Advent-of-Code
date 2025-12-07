import Foundation
import StandardLibraries

public struct Day7 {
    public init() {}

    enum Key {
        static let start = "S"
        static let empty = "."
        static let splitter = "^"
    }

    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var points = grid.points(for: Key.start)
        var visited = Set<Point>()

        while !points.isEmpty {
            let point = points.removeFirst()
            let next = point.down()

            guard next.y < grid.rows else { continue }

            if grid[next] == Key.splitter {
                guard !visited.contains(next) else { continue }
                visited.insert(next)
                let left = next.left()
                let right = next.right()
                if left.x >= 0 {
                    points.append(left)
                }
                if right.x < grid.columns {
                    points.append(right)
                }
            } else {
                points.append(next)
            }
        }

        return visited.count
    }

    public func part2(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var points = [grid.points(for: Key.start).first!: 1]
        var splitters: [Point: Int] = [:]

        while !points.isEmpty {
            var pending: [Point: Int] = [:]

            for (point, value) in points {
                let next = point.down()
                guard next.y < grid.rows else { continue }

                if grid[next] == Key.splitter {
                    splitters[next] = splitters[next, default: 0] + value
                    pending[next.left()] = pending[next.left(), default: 0] + value
                    pending[next.right()] = pending[next.right(), default: 0] + value
                } else {
                    pending[next] = pending[next, default: 0] + value
                }
            }

            points = pending
        }

        return splitters.reduce(1) { $0 + $1.value }
    }
}
