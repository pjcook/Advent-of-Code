import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let points = parse(input)
        var highest = 0

        for i in 0..<points.count {
            let p1 = points[i]
            for j in i..<points.count {
                let p2 = points[j]
                let area = p1.area(with: p2)
                if area > highest {
                    highest = area
                }
            }
        }

        return highest
    }

    public func part2(_ input: [String]) -> Int {
        let points = parse(input)
        var highest = 0

        for i in 0..<points.count-1 {
            let p1 = points[i]
            loop: for j in i+1..<points.count {
                let p2 = points[j]
                guard p1.x != p2.x, p1.y != p2.y else { continue }
                guard (p2.x > p1.x && p2.y > p1.y) || (p1.x > p2.x && p1.y > p2.y) ||
                      (p2.x > p1.x && p2.y < p1.y) || (p1.x > p2.x && p1.y < p2.y) else {
                    continue
                }

                let minX = min(p1.x, p2.x)+1
                let maxX = max(p1.x, p2.x)-1
                let minY = min(p1.y, p2.y)+1
                let maxY = max(p1.y, p2.y)-1

                let rx1 = min(minX, maxX)...max(minX, maxX)
                let ry1 = min(minY, maxY)...max(minY, maxY)

                for point in points where point != p1 && point != p2 && point != Point(p1.x, p2.y) && point != Point(p2.x, p1.y) {

                    let (n1, n2) = neighbours(of: point, in: points)

                    let rx2 = min(n1.x, point.x)...max(n1.x, point.x)
                    let ry2 = min(n1.y, point.y)...max(n1.y, point.y)

                    let rx3 = min(n2.x, point.x)...max(n2.x, point.x)
                    let ry3 = min(n2.y, point.y)...max(n2.y, point.y)

                    if (rx1.overlaps(rx2) && ry1.overlaps(ry2)) ||
                        (rx1.overlaps(rx3) && ry1.overlaps(ry3)) {
                        continue loop
                    }
                }

                let area = p1.area(with: p2)
                if area > highest {
                    highest = area
                }
            }
        }

        return highest
    }
}

extension Point {
    func area(with point: Point) -> Int {
        (abs(x - point.x)+1) * (abs(y - point.y)+1)
    }
}

extension Day9 {
    func neighbours(of point: Point, in points: [Point]) -> (Point, Point) {
        let index = points.firstIndex(of: point)!
        var firstIndex = index - 1
        if firstIndex < 0 {
            firstIndex = points.count - 1
        }
        var lastIndex = index + 1
        if lastIndex >= points.count {
            lastIndex = 0
        }
        return (points[firstIndex], points[lastIndex])
    }

    func parse(_ input: [String]) -> [Point] {
        input.map {
            let parts = $0.components(separatedBy: ",").map(Int.init)
            return Point(x: parts[0]!, y: parts[1]!)
        }
    }
}
