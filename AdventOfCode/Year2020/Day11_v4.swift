import Foundation
import StandardLibraries

public class Day11_v4 {
    public init() {}
    
    public enum Option: Character {
        case emptySeat = "L", occupiedSeat = "#", floor = "."
    }
    
    public func part1(_ input: [[Option]]) -> Int {
        return calculate(input, visibleSeats: 4, buildAdjacent: findAdjacent_part1)
    }
    
    public func part2(_ input: [[Option]]) -> Int {
        return calculate(input, visibleSeats: 5, buildAdjacent: findAdjacent_part2)
    }
    
    func calculate(_ input: [[Option]], visibleSeats: Int, buildAdjacent: (Point, [[Option]]) -> Void) -> Int {
        let max = Point(x: input[0].count, y: input.count)
        buildAdjacent(max, input)
        var previous = input
        var isSame = true
        while isSame {
            let updated = step(previous, visibleSeats: visibleSeats, max: max)
            isSame = updated != previous
            previous = updated
        }
        
        return previous
            .compactMap({ $0.compactMap({ $0 == .occupiedSeat ? 1 : 0 }).reduce(0, +) })
            .reduce(0, +)
    }

    public func step(_ input: [[Option]], visibleSeats: Int = 4, max: Point) -> [[Option]] {
        var output = input
        
        for y in 0..<max.y {
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                let value = input[y][x]
                guard value != .floor else { continue }
                let count = countOccupied(point, input: input)
                if value == .emptySeat, count == 0 {
                    output[y][x] = .occupiedSeat
                } else if value == .occupiedSeat, count >= visibleSeats {
                    output[y][x] = .emptySeat
                }
            }
        }
        
        return output
    }

    var adjacent = [Point:[Point]]()
    func findAdjacent_part1(max: Point, input: [[Option]]) {
        let points = Point.adjacentPoints
        for y in 0..<max.y {
            for x in 0..<max.x {
                let point = Point(x: x, y: y)
                adjacent[point] = points
                    .map { point + $0 }
                    .filter { $0.isValid(max: max) }
            }
        }
    }
    
    func findAdjacent_part2(max: Point, input: [[Option]]) {
        let points = Point.adjacentPoints
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
                        if input[pos.y][pos.x] != .floor {
                            validPoints.append(pos)
                            exit = true
                        }
                    }
                }
                
                adjacent[point] = validPoints
            }
        }
    }
    
    func countOccupied(_ point: Point, input: [[Option]]) -> Int {
        return adjacent[point]!.filter { input[$0.y][$0.x] == .occupiedSeat }.count
    }
}
