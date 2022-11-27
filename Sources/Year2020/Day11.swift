import Foundation
import StandardLibraries

public class Day11 {
    public init() {}
    
    public func part1(_ input: [[Character]]) -> Int {
        return calculate(input, visibleSeats: 4, buildAdjacent: findAdjacent_part1)
    }
    
    public func part2(_ input: [[Character]]) -> Int {
        return calculate(input, visibleSeats: 5, buildAdjacent: findAdjacent_part2)
    }
    
    func calculate(_ input: [[Character]], visibleSeats: Int, buildAdjacent: (Point, [[Character]]) -> Void) -> Int {
        let max = Point(x: input[0].count, y: input.count)
        buildAdjacent(max, input)
        var previous = input
        var isSame = true
        var count = 0
        while isSame {
            let updated = step(previous, visibleSeats: visibleSeats, max: max)
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
    
    public func step(_ input: [[Character]], visibleSeats: Int = 4, max: Point) -> [[Character]] {
        var output = input
        
        for y in 0..<max.y {
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                let value = input[y][x]
                guard value != "." else { continue }
                let count = countOccupied(point, input: input)
                if value == "L", count == 0 {
                    output[y][x] = "#"
                } else if value == "#", count >= visibleSeats {
                    output[y][x] = "L"
                }
            }
        }
        
        return output
    }

    var adjacent = [Point:[Point]]()
    func findAdjacent_part1(max: Point, input: [[Character]]) {
        let points = Point.adjacent
        for y in 0..<max.y {
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                adjacent[point] = points
                    .map { point + $0 }
                    .filter { $0.isValid(max: max) }
            }
        }
    }
    
    func findAdjacent_part2(max: Point, input: [[Character]]) {
        let points = Point.adjacent
        for y in 0..<max.y {
            for x in 0..<max.x {
                var validPoints = [Point]()
                let point = Point(x: x, y: y)
                outerLoop: for pt in points {
                    var pos = point
                    var exit = false
                    while !exit {
                        pos = pos + pt
                        guard pos.isValid(max: max) else {
                            exit = true
                            continue outerLoop
                        }
                        if input[pos.y][pos.x] != "." {
                            validPoints.append(pos)
                            exit = true
                        }
                    }
                }
                
                adjacent[point] = validPoints
            }
        }
    }
    
    func countOccupied(_ point: Point, input: [[Character]]) -> Int {
        return adjacent[point]!.filter { input[$0.y][$0.x] == "#" }.count
    }
}
