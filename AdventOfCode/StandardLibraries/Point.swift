import Foundation

public struct Point: Hashable {
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
}

extension Point {
    public func distance(to other: Point) -> Int {
        return abs(x - other.x) + abs(y - other.y)
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
    
    func cardinalNeighbors(_ allowNegative: Bool = false) -> Set<Point> {
        return Set([
            Point(x, y-1),
            Point(x-1, y),
            Point(x+1, y),
            Point(x, y+1)
        ].filter({ allowNegative || $0.x >= 0 && $0.y >= 0 })
        )
    }
}

public enum Position {
    case tl, t, tr
    case l, m, r
    case bl, b, br
    
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
        print((4 + (rawValue - (times % 4))) % 4)
        return CompassDirection(rawValue: (4 + (rawValue - (times % 4))) % 4) ?? self
    }
    
    func rotateRight(times: Int) -> CompassDirection {
        return CompassDirection(rawValue: (rawValue + times) % 4) ?? self
    }
}

public enum Direction: Int {
    case left, right, straight
}
