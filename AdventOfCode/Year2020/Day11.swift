import Foundation
import StandardLibraries

public struct Day11 {
    
    public func part1(_ input: [[Character]]) -> Int {
        return calculate(input, visibleSeats: 4, countOccupied: countOccupied_part1)
    }
    
    public func part2(_ input: [[Character]]) -> Int {
        return calculate(input, visibleSeats: 5, countOccupied: countOccupied_part2)
    }
    
    func calculate(_ input: [[Character]], visibleSeats: Int, countOccupied: (Point, Point, [[Character]]) -> Int) -> Int {
        var previous = input
        var isSame = true
        var count = 0
        while isSame {
            let updated = step(previous, visibleSeats: visibleSeats, countOccupied: countOccupied)
            isSame = updated != previous
            previous = updated
            count += 1
        }
        
        return previous
            .compactMap({ $0.compactMap({ $0 == "#" ? 1 : 0 }).reduce(0, +) })
            .reduce(0, +)
    }

    func draw(_ input: [[Character]]) {
        input.forEach {
            print($0.map { String($0) }.joined())
        }
    }
    
    public func step(_ input: [[Character]], visibleSeats: Int = 4, countOccupied: (Point, Point, [[Character]]) -> Int) -> [[Character]] {
        var output = input
        let max = Point(x: input[0].count, y: input.count)
        
        for y in 0..<max.y {
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                let value = input[y][x]
                guard value != "." else { continue }
                let count = countOccupied(point, max, input)
                if value == "L", count == 0 {
                    output[y][x] = "#"
                } else if value == "#", count >= visibleSeats {
                    output[y][x] = "L"
                }
            }
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
    func countOccupied_part1(_ point: Point, max: Point, input: [[Character]]) -> Int {
        return points
            .map { point + $0 }
            .filter { $0.isValid(max: max) }
            .filter { input[$0.y][$0.x] == "#" }
            .count
    }
    
    func countOccupied_part2(_ point: Point, max: Point, input: [[Character]]) -> Int {
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
