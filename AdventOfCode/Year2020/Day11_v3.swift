import Foundation
import StandardLibraries

public struct Day11_v3 {
    public func part1(_ input: [String]) -> Int {
        return calculate(input, visibleSeats: 4, useFilter: true, countOccupied: countOccupied_part1)
    }
    
    public func part2(_ input: [String]) -> Int {
        return calculate(input, visibleSeats: 5, useFilter: false, countOccupied: countOccupied_part2)
    }
    
    func calculate(_ input: [String], visibleSeats: Int, useFilter: Bool, countOccupied: (Point, Point, [String]) -> Int) -> Int {
        var previous = input, isSame = true
        while isSame {
            let updated = step(previous, visibleSeats: visibleSeats, countOccupied: countOccupied, useFilter: useFilter)
            isSame = updated != previous
            previous = updated
        }
        return previous
            .joined()
            .reduce(0) { $0 + ($1 == "#" ? 1 : 0) }
    }
    
    func step(_ input: [String], visibleSeats: Int, countOccupied: (Point, Point, [String]) -> Int, useFilter: Bool) -> [String] {
        var output = input
        let max = Point(x: input[0].count, y: input.count)
        
        for y in 0..<max.y {
            var line = [String]()
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                let value = input[y][x]
                guard value != "." else {
                    line.append(value)
                    continue
                }
                let count = countOccupied(point, max, input)
                if value == "L", count == 0 {
                    line.append("#")
                } else if value == "#", count >= visibleSeats {
                    line.append("L")
                } else {
                    line.append(value)
                }
            }
            output[y] = line.joined()
        }

        return output
    }
    
    let points: [Point] = [
        Point(x: -1, y: -1),
        Point(x: 0, y: -1),
        Point(x: 1, y: -1),
        Point(x: -1, y: 0),
        Point(x: 1, y: 0),
        Point(x: -1, y: 1),
        Point(x: 0, y: 1),
        Point(x: 1, y: 1),
    ]
    func countOccupied_part1(_ point: Point, max: Point, input: [String]) -> Int {
        return points
            .map({ point + $0 })
            .filter { $0.isValid(max: max) }
            .filter({ input[$0.y][$0.x] == "#" })
            .count
    }

    func countOccupied_part2(_ point: Point, max: Point, input: [String]) -> Int {
        var count = 0
        outerLoop: for position in points {
            var exit = false
            var pos = point
            while !exit {
                pos = pos + position
                if pos.isValid(max: max) {
                    let value = input[pos.y][pos.x]
                    if value == "#" {
                        count += 1
                        exit = true
                    } else if value == "L" {
                        exit = true
                    }
                } else {
                    exit = true
                }
                if count >= 5 {
                    break outerLoop
                }
            }
        }
                
        return count
    }
}
