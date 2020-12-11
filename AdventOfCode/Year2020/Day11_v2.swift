import Foundation
import StandardLibraries

public struct Day11_v2 {
    public func part1(_ input: [Point:Character]) -> Int {
        return calculate(input, visibleSeats: 4, useFilter: true, countOccupied: countOccupied_part1)
    }
    
    public func part2(_ input: [Point:Character]) -> Int {
        return calculate(input, visibleSeats: 5, useFilter: false, countOccupied: countOccupied_part2)
    }
    
    func calculate(_ input: [Point:Character], visibleSeats: Int, useFilter: Bool, countOccupied: (Point, Point, [Point:Character]) -> Int) -> Int {
        var previous = input, isSame = true
        while isSame {
            let updated = step(previous, visibleSeats: visibleSeats, countOccupied: countOccupied, useFilter: useFilter)
            isSame = updated != previous
            previous = updated
        }
        return previous.filter({ $0.value == "#" }).count
    }
    
    func step(_ input: [Point:Character], visibleSeats: Int, countOccupied: (Point, Point, [Point:Character]) -> Int, useFilter: Bool) -> [Point:Character] {
        var output = input
        let max = Point(x: 96, y: 90)
        let filtered = useFilter ? input.filter { $0.value == "#" } : input
        
        for element in input {
            let point = element.key
            let value = element.value
            guard value != "." else { continue }
            let count = countOccupied(point, max, filtered)
            if value == "L", count == 0 {
                output[point] = "#"
            } else if value == "#", count >= visibleSeats {
                output[point] = "L"
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
    func countOccupied_part1(_ point: Point, max: Point, input: [Point:Character]) -> Int {
        return points.reduce(0) { $0 + (input[point + $1] != nil ? 1 : 0) }
    }

    func countOccupied_part2(_ point: Point, max: Point, input: [Point:Character]) -> Int {
        var count = 0
        
        outerLoop: for p in points {
            var exit = false
            var pos = point
            while !exit {
                pos = pos + p
                guard let value = input[pos] else {
                    exit = true
                    continue
                }
                if value != "." {
                    if value == "#" {
                        count += 1
                        if count > 4 {
                            break outerLoop
                        }

                    }
                    exit = true
                }
            }
        }
        
        return count
    }

    public static func toDict(_ input: [String]) -> [Point:Character] {
        var output = [Point:Character]()

        var y = 0
        for line in input {
            y += 1
            for (x, value) in line.enumerated() {
                output[Point(x: x, y: y)] = value
            }
        }
        
        return output
    }
}
