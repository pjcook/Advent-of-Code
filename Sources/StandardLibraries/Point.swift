import Foundation

public struct Point: Hashable, Comparable, CustomStringConvertible {
    public var x: Int
    public var y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static let zero: Point = Point(x: 0, y: 0)
    
    public func up() -> Point { Point(x, y-1) }
    public func down() -> Point { Point(x, y+1) }
    public func left() -> Point { Point(x-1, y) }
    public func right() -> Point { Point(x+1, y) }
    
    public var description: String { "(\(x),\(y))" }
}

extension Point {
    public static func pointsIn(_ topRight: Point, _ bottomLeft: Point) -> Set<Point> {
        var points = Set<Point>()
        
        for y in (topRight.y...bottomLeft.y) {
            for x in (topRight.x...bottomLeft.x) {
                points.insert(Point(x,y))
            }
        }
        
        return points
    }
    
    public func isInArea(p1: Point, p2: Point) -> Bool {
        let minX = min(p1.x, p2.x)
        let maxX = max(p1.x, p2.x)
        let minY = min(p1.y, p2.y)
        let maxY = max(p1.y, p2.y)
        return (minX...maxX).contains(x) && (minY...maxY).contains(y)
    }
    
    public func distance(to: Point) -> Double {
        sqrt(pow(Double(x - to.x), 2) + pow(Double(y - to.y), 2))
    }
    
    public func manhattanDistance(to point: Point) -> Int {
        abs(point.x - x) + abs(point.y - y)
    }
        
    public var manhattanDistance: Int {
        abs(x) + abs(y)
    }
    
    public func adjacent(_ position: Position, _ min: Point, _ max: Point) -> Point? {
        let point = self + position.point
        guard point.x >= min.x && point.x < max.x && point.y >= min.y && point.y < max.y else {
            return nil
        }
        return point
    }
    
    public func isValid(max: Point) -> Bool {
        return x >= 0 && x < max.x && y >= 0 && y < max.y
    }
    
    public static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func / (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    public static func * (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    public static func * (lhs: Point, rhs: Int) -> Point {
        return Point(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    public static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    public static func <= (lhs: Point, rhs: Point) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y
    }
    
    public static func > (lhs: Point, rhs: Point) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    public static func >= (lhs: Point, rhs: Point) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
    public func add(direction: CompassDirection, distance: Int = 1) -> Point {
        switch direction {
        case .n: return Point(x: x, y: y + distance)
        case .s: return Point(x: x, y: y - distance)
        case .e: return Point(x: x + distance, y: y)
        case .w: return Point(x: x - distance, y: y)
        }
    }
    
    public func rotateLeft(angle: Int) -> Point {
        switch angle / 90 {
        case 1: return Point(x: -y, y: x)
        case 2: return Point(x: -x, y: -y)
        case 3: return Point(x: y, y: -x)
        default: return self
        }
    }
    
    public func rotateRight(angle: Int) -> Point {
        switch angle / 90 {
        case 1: return Point(x: y, y: -x)
        case 2: return Point(x: -x, y: -y)
        case 3: return Point(x: -y, y: x)
        default: return self
        }
    }
    
    public func rotateLeft(times: Int) -> Point {
        switch times {
        case 1: return Point(x: -y, y: x)
        case 2: return Point(x: -x, y: -y)
        case 3: return Point(x: y, y: -x)
        default: return self
        }
    }
    
    public func rotateRight(times: Int) -> Point {
        switch times {
        case 1: return Point(x: y, y: -x)
        case 2: return Point(x: -x, y: -y)
        case 3: return Point(x: -y, y: x)
        default: return self
        }
    }
}

public extension Point {
    static var adjacent: Set<Point> = {
        var items = Set<Point>()
        for y in (-1...1) {
            for x in (-1...1) {
                items.insert(Point(x: x, y: y))
            }
        }
        items.remove(.zero)
        return items
    }()
    
    func cardinalNeighbors(_ allowNegative: Bool = false, min: Point = .zero, max: Point? = nil) -> Set<Point> {
        return Set([
            Point(x, y-1),
            Point(x-1, y),
            Point(x+1, y),
            Point(x, y+1)
        ]
            .filter({ allowNegative || $0.x >= min.x && $0.y >= min.y })
            .filter({ max == nil || $0.x < max!.x && $0.y < max!.y })
        )
    }
    
    func neighbors(_ allowNegative: Bool = false, min: Point = .zero, max: Point? = nil) -> Set<Point> {
        return Set([
            Point(x-1, y-1),
            Point(x, y-1),
            Point(x+1, y-1),
            Point(x-1, y),
            Point(x+1, y),
            Point(x-1, y+1),
            Point(x, y+1),
            Point(x+1, y+1)
        ]
            .filter({ allowNegative || $0.x >= min.x && $0.y >= min.y })
            .filter({ max == nil || $0.x < max!.x && $0.y < max!.y })
        )
    }
    
    func position(from origin: Point) -> Position? {
        for position in Position.all {
            if origin + position.point == self {
                return position
            }
        }
        return nil
    }
}

public enum Position {
    case tl, t, tr
    case l, m, r
    case bl, b, br
    
    static let all: [Position] = [.tl, .t, .tr, .l, .m, .r, .bl, .b, .br]
    
    public var point: Point {
        switch self {
        case .tl: return Point(x: -1, y: -1)
        case .t: return Point(x: 0, y: -1)
        case .tr: return Point(x: 1, y: -1)
        case .l: return Point(x: -1, y: 0)
        case .m: return Point(x: 0, y: 0)
        case .r: return Point(x: 1, y: 0)
        case .bl: return Point(x: -1, y: 1)
        case .b: return Point(x: 0, y: 1)
        case .br: return Point(x: 1, y: 1)
        }
    }
}

public enum CompassDirection: Int {
    case n = 0, e = 1, s = 2, w = 3
}

public extension CompassDirection {
    func rotateLeft() -> CompassDirection {
        switch self {
        case .n: return .w
        case .s: return .e
        case .e: return .n
        case .w: return .s
        }
    }
    
    func rotateRight() -> CompassDirection {
        switch self {
        case .n: return .e
        case .s: return .w
        case .e: return .s
        case .w: return .n
        }
    }
    
    func rotateLeft(times: Int) -> CompassDirection {
        return CompassDirection(rawValue: (4 + (rawValue - (times % 4))) % 4) ?? self
    }
    
    func rotateRight(times: Int) -> CompassDirection {
        return CompassDirection(rawValue: (rawValue + times) % 4) ?? self
    }
}

public enum Direction: Int, Hashable, CaseIterable {
    case left = 0
    case down = 1
    case right = 2
    case up = 3
    
    public var point: Point {
        switch self {
        case .up: return Point(0, -1)
        case .left: return Point(-1, 0)
        case .right: return Point(1, 0)
        case .down: return Point(0, 1)
        }
    }
    
    public var opposite: Direction {
        switch self {
            case .up:
                .down
            case .down:
                .up
            case .left:
                .right
            case .right:
                .left
        }
    }
}

public enum MovementDirection: Int {
    case left, right, straight
}

public extension Point {
    // https://www.cuemath.com/geometry/equation-of-a-straight-line/
    // point-slope-form m = (y - y1)/(x - x1) // calculate the angle `m` of the slope between 2 points
    static func findAngle(p1: Point, p2: Point) -> Double {
        if p1.x < p2.x {
            return Double(p1.y - p2.y) / Double(p1.x - p2.x)
        } else {
            return Double(p2.y - p1.y) / Double(p2.x - p1.x)
        }
    }
    
    // find b
    // y = mx + b
    static func slope(p1: Point, m: Double) -> Double {
        Double(p1.y) - (m * Double(p1.x))
    }
    
    static func slope(m1: Double, m2: Double, b1: Double, b2: Double) -> Double {
        (b2 - b1) / (m1 + m2)
    }
}

public struct Line {
    public let a: Double
    public let b: Double
    public let c: Double
    
    public init(p1: Point, p2: Point) {
        let ordered = [p1, p2].sorted { $0.x < $1.x }
        self.a = Double(ordered[0].y - ordered[1].y)
        self.b = Double(ordered[1].x - ordered[0].x)
        self.c = Double(-((ordered[0].x * ordered[1].y) - (ordered[1].x * ordered[0].y)))
    }
    
}

public func intersectionOfLines(line1: Line, line2: Line) -> (Double, Double)? {
    let d = line1.a * line2.b - line1.b * line2.a
    let dx = line1.c * line2.b - line1.b * line2.c
    let dy = line1.a * line2.c - line1.c * line2.a
    
    guard d != 0 else { return nil }
    let x = dx / d
    let y = dy / d
    return (x,y)
}
