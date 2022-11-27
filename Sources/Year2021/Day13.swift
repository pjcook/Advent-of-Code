import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    public enum Fold {
        case x(Int)
        case y(Int)
    }
    public typealias Points = Set<Point>
    public typealias Folds = [Fold]
    
    public func part1(_ input: [String]) -> Int {
        var (points, folds) = parse(input)
        switch folds.first! {
        case let .x(value): foldHorizontal(&points, x: value)
        case let .y(value): foldVertical(&points, y: value)
        }

        return points.count
    }
    
    public func part2(_ input: [String]) -> Int {
        var (points, folds) = parse(input)

        for fold in folds {
            switch fold {
            case let .x(value): foldHorizontal(&points, x: value)
            case let .y(value): foldVertical(&points, y: value)
            }
        }
        draw(points)

        return points.count
    }
        
    public func foldHorizontal(_ points: inout Points, x: Int) {
        let items = points
        for point in items {
            if point.x > x {
                let newPoint = Point(2 * x - point.x, point.y)
                points.remove(point)
                points.insert(newPoint)
            }
        }
    }
    
    public func foldVertical(_ points: inout Points, y: Int) {
        let items = points
        for point in items {
            if point.y > y {
                let newPoint = Point(point.x, 2 * y - point.y)
                points.remove(point)
                points.insert(newPoint)
            }
        }
    }
    
    public func parse(_ input: [String]) -> (Points, Folds) {
        var points = Points()
        var folds = Folds()
        var processFolds = false
        
        for line in input {
            if line.isEmpty {
                processFolds = true
                continue
            }
            if !processFolds {
                let split = line.split(separator: ",")
                points.insert(Point(Int(String(split[0]))!,Int(String(split[1]))!))
            } else {
                let split = line.split(separator: "=")
                let value = Int(String(split[1]))!
                if split[0].last! == "x" {
                    folds.append(.x(value))
                } else {
                    folds.append(.y(value))
                }
            }
        }
        
        return (points, folds)
    }
    
    public func draw(_ points: Points) {
        let (minP, maxP) = extremes(Array(points))
        for y in (minP.y...maxP.y) {
            var row = ""
            for x in (minP.x...maxP.x) {
                points.contains(Point(x,y)) ? row.append("#") : row.append(".")
            }
            print(row)
        }
        print()
    }
    
    public func extremes(_ points: [Point]) -> (Point,Point) {
        var minX = Int.max
        var minY = Int.max
        var maxX = 0
        var maxY = 0
        for point in points {
            minX = min(point.x, minX)
            minY = min(point.y, minY)
            maxX = max(point.x, maxX)
            maxY = max(point.y, maxY)
        }
        return (Point(minX, minY), Point(maxX, maxY))
    }
}
