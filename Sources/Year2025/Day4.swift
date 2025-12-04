import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        var count = 0

        for y in 0..<grid.rows {
            for x in 0..<grid.columns {
                let point = Point(x, y)
                guard grid[point] == "@" else { continue }
                let neighborRolls = point
                    .neighbors(max: grid.bottomRight)
                    .map { grid[$0] == "@" ? 1 : 0 }
                    .reduce(0, +)
                if neighborRolls < 4 {
                    count += 1
                }
            }
        }

        return count
    }

    public func part2(_ input: [String]) -> Int {
        var grid = Grid<String>(input)
        var count = 0
        var changed = true

        while changed {
            var rollsToRemove: [Point] = []
            for y in 0..<grid.rows {
                for x in 0..<grid.columns {
                    let point = Point(x, y)
                    guard grid[point] == "@" else { continue }
                    let neighborRolls = point
                        .neighbors(max: grid.bottomRight)
                        .map { grid[$0] == "@" ? 1 : 0 }
                        .reduce(0, +)
                    if neighborRolls < 4 {
                        rollsToRemove.append(point)
                    }
                }
            }

            count += rollsToRemove.count
            changed = rollsToRemove.isEmpty == false
            for point in rollsToRemove {
                grid[point] = "."
            }
        }

        return count
    }
}
