import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    public typealias Points = [Point:Bool]
    public typealias Folds = [Point]
    
    public func part1(_ input: [String]) -> Int {
        var (points, folds) = parse(input)
        let fold = folds.first!
        
//        draw(points)
        if fold.x == 0 {
            foldVertical(&points, y: fold.y)
        } else {
            foldHorizontal(&points, x: fold.x)
        }

//        draw(points)
        return points.filter({ $0.value == true }).count
    }
    
    public func part2(_ input: [String]) -> Int {
        var (points, folds) = parse(input)
//        printExtremes(points)
        for fold in folds {
            if fold.x == 0 {
                foldVertical(&points, y: fold.y)
            } else {
                foldHorizontal(&points, x: fold.x)
            }
//            printExtremes(points)
        }
        draw(points)

        return points.filter({ $0.value == true }).count
    }
    
    public func printExtremes(_ points: Points) {
        let (minP, maxP) = extremes(Array(points.keys))
        print(minP, maxP)
    }
    
    public func draw(_ points: Points) {
        let (minP, maxP) = extremes(Array(points.keys))
        print(minP, maxP)
        for y in (minP.y...maxP.y) {
            var row = ""
            for x in (minP.x...maxP.x) {
                points[Point(x,y), default: false] ? row.append("#") : row.append(".")
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
    
    public func foldHorizontal(_ points: inout Points, x: Int) {
        let (_, maxP) = extremes(Array(points.keys))

        // filter out the max placeholder
        for point in points.keys.filter({ points[$0] == false }) {
            points.removeValue(forKey: point)
        }

        for point in points.keys {
            if point.x > x {
                let newPoint = Point(maxP.x - point.x, point.y)
                points.removeValue(forKey: point)
                points[newPoint] = true
            }
        }
        
        // Add a bottom right corner to keep the correct size of the grid
        let maxPoint = Point(maxP.x - x - 1, maxP.y)
        if points[maxPoint] == nil {
            points[maxPoint] = false
        }
    }
    
    public func foldVertical(_ points: inout Points, y: Int) {
        let (_, maxP) = extremes(Array(points.keys))

        // filter out the max placeholder
        for point in points.keys.filter({ points[$0] == false }) {
            points.removeValue(forKey: point)
        }

        for point in points.keys {
            if point.y > y {
                let newPoint = Point(point.x, maxP.y - point.y)
                points.removeValue(forKey: point)
                points[newPoint] = true
            }
        }
        
        // Add a bottom right corner to keep the correct size of the grid
        let maxPoint = Point(maxP.x, maxP.y - y - 1)
        if points[maxPoint] == nil {
            points[maxPoint] = false
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
                let point = Point(Int(String(split[0]))!,Int(String(split[1]))!)
                points[point] = true
            } else {
                let split = line.split(separator: "=")
                if split[0].last! == "x" {
                    folds.append(Point(Int(String(split[1]))!, 0))
                } else {
                    folds.append(Point(0, Int(String(split[1]))!))
                }
            }
        }
        
        return (points, folds)
    }
}
