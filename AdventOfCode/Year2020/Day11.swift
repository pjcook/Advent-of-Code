import Foundation
import StandardLibraries

/*
 If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
 If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
 Otherwise, the seat's state does not change.
 L Empty
 . Floor
 # Occupied
 */
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
    
    let positions: [Position] = [.tl, .t, .tr, .l, .r, .bl, .b, .br]
    func countOccupied_part1(_ point: Point, max: Point, input: [[Character]]) -> Int {
        return positions
            .compactMap({ point.adjacent($0, .zero, max) })
            .map({ input[$0.y][$0.x] == "#" ? 1 : 0 })
            .reduce(0, +)
    }
    
    func countOccupied_part2(_ point: Point, max: Point, input: [[Character]]) -> Int {
        var count = 0
        outerLoop: for position in positions {
            var exit = false
            var pos = point
            while !exit {
                if let p = pos.adjacent(position, .zero, max) {
                    pos = p
                    let value = input[p.y][p.x]
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
