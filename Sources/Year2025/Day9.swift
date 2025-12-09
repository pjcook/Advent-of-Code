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
        print(points.minMax())
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

                let minX = min(p1.x, p2.x)
                let maxX = max(p1.x, p2.x)
                let minY = min(p1.y, p2.y)
                let maxY = max(p1.y, p2.y)

                for point in points where point != p1 && point != p2 && point != Point(p1.x, p2.y) && point != Point(p2.x, p1.y) {
                    if (minX...maxX).contains(point.x) && (minY...maxY).contains(point.y) {
                        if point.x == minX {
                            let (n1, n2) = neighbours(of: point, in: points)
                            let n3 = n1.y == point.y ? n1 : n2
                            if n3.x > minX {
                                continue loop
                            }
                        } else if point.x == maxX {
                            let (n1, n2) = neighbours(of: point, in: points)
                            let n3 = n1.y == point.y ? n1 : n2
                            if n3.x < maxX {
                                continue loop
                            }
                        } else if point.y == minY {
                            let (n1, n2) = neighbours(of: point, in: points)
                            let n3 = n1.x == point.x ? n1 : n2
                            if n3.y > minY {
                                continue loop
                            }
                        } else if point.y == maxY {
                            let (n1, n2) = neighbours(of: point, in: points)
                            let n3 = n1.x == point.x ? n1 : n2
                            if n3.y < maxY {
                                continue loop
                            }
                        } else {
                            continue loop
                        }
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
