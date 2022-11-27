import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
        
    public func part1(_ serialNumber: Int) -> Point {
        let values = calculatePowerLevels(serialNumber)
        return findLargestPowerSquare(values)
    }
    
    public func part2(_ serialNumber: Int) -> (Point, Int) {
        let values = calculatePowerLevels(serialNumber)
        return findLargestPowerSquare2(values)
    }
    
    public func calculatePowerLevels(_ serialNumber: Int) -> [Point: Int] {
        var values = [Point: Int]()
        for y in (1...300) {
            for x in (1...300) {
                let point = Point(x: x, y: y)
                let value = calculatePowerLevel(x, y, serialNumber)
                values[point] = value
            }
        }
        return values
    }
    
    public func calculatePowerLevel(_ x: Int, _ y: Int, _ serialNumber: Int) -> Int {
        let rackID = x + 10
        var powerLevel = rackID * y
        powerLevel += serialNumber
        powerLevel *= rackID
        powerLevel /= 100
        return Int(String(String(powerLevel).last!))! - 5
    }
    
    public func findLargestPowerSquare(_ values: [Point: Int]) -> Point {
        var max = 0
        var topLeft = Point.zero
        
        for y in (2..<300) {
            for x in (2..<300) {
                let point = Point(x: x, y: y)
                var value = values[point]!
                for p in Point.adjacent {
                    value += values[point + p]!
                }
                if value > max {
                    max = value
                    topLeft = point + Point(x: -1, y: -1)
                }
            }
        }
        
        return topLeft
    }
    
    public func findLargestPowerSquare2(_ values: [Point: Int]) -> (Point, Int) {
        var maxValue = 0
        var topLeft = Point.zero
        var size = 1
        var count = 1
        for y in (1...300) {
            for x in (1...300) {
                let point = Point(x: x, y: y)
                var value = values[point]!

                let m = max(1, min(300-y, 300-x))
                for y2 in (1..<m) {
                    var points = Set<Point>()
                    for x2 in (0...y2) {
                        points.insert(Point(x: x+y2, y: y+x2))
                        points.insert(Point(x: x+x2, y: y+y2))
                    }
                    
                    for p in points {
                        value += values[p, default: 0]
                    }
                    
                    if value > maxValue {
                        maxValue = value
                        topLeft = point
                        size = y2 + 1
                        print(point, count, "\(topLeft.x),\(topLeft.y),\(size)", maxValue)
                    }
                }

                count += 1
                if count % 5000 == 0 {
                    print(count)
                }
            }
        }
        
        return (topLeft, size)
    }
}
