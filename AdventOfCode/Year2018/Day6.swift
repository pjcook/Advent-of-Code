import Foundation
import StandardLibraries

public struct Day6 {
    public func part1(_ input: [String]) -> Int {
        let points = input.map { $0.components(separatedBy: ", ") }
            .map { Point(x: Int($0[0])!, y: Int($0[1])!) }
        
        let maxX = points.reduce(0) { $0 > $1.x ? $0 : $1.x }
        let maxY = points.reduce(0) { $0 > $1.y ? $0 : $1.y }
        let minX = points.reduce(maxX) { $0 < $1.x ? $0 : $1.x }
        let minY = points.reduce(maxY) { $0 < $1.y ? $0 : $1.y }
        var dict = points.reduce(into: Dictionary<Point,Point>()) { $0[$1] = $1 }

        for x in minX...maxX {
            for y in minY...maxY {
                let point = Point(x: x, y: y)
                if dict[point] == nil {
                    let distances = points
                        .map { ($0, point.manhattanDistance(to: $0)) }
                        .sorted(by: { $0.1 < $1.1 })
                    if distances[0].1 != distances[1].1 {
                        dict[point] = distances[0].0
                    }
                }
            }
        }
        
        let counts = dict
            .reduce(into: [Point:Int]()) { $0[$1.value] = ($0[$1.value, default: 0]) + 1 }
            .sorted(by: { $0.value > $1.value  })
            
        return counts
            .compactMap {
                dict[Point(x: $0.key.x, y: minY)] != $0.key &&
                dict[Point(x: $0.key.x, y: maxY)] != $0.key &&
                dict[Point(x: minX, y: $0.key.y)] != $0.key &&
                dict[Point(x: maxX, y: $0.key.y)] != $0.key ? $0 : nil
            }
            .first?
            .value ?? 0
    }
    
    public func part2(_ input: [String]) -> Int {
        let points = input.map { $0.components(separatedBy: ", ") }
            .map { Point(x: Int($0[0])!, y: Int($0[1])!) }
        
        let maxX = points.reduce(0) { $0 > $1.x ? $0 : $1.x }
        let maxY = points.reduce(0) { $0 > $1.y ? $0 : $1.y }
        let minX = points.reduce(maxX) { $0 < $1.x ? $0 : $1.x }
        let minY = points.reduce(maxY) { $0 < $1.y ? $0 : $1.y }
        var areaPoints = [Point]()
        
        for x in minX...maxX {
            for y in minY...maxY {
                let point = Point(x: x, y: y)
                let distance = points
                    .map { point.manhattanDistance(to: $0) }
                    .reduce(0, +)
                if distance < 10000 {
                    areaPoints.append(point)
                }
            }
        }
        
        return areaPoints.count
    }
}

public extension Point {
    func manhattanDistance(to point: Point) -> Int {
        abs(point.x - x) + abs(point.y - y)
    }
    
    func distance(to point: Point) -> Double {
        let dx = Double(abs(point.x - x))
        let dy = Double(abs(point.y - y))
        return sqrt(dx * dx + dy * dy)
    }
}
