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
    
    public init(_ vector: Vector) {
        self.x = vector.x
        self.y = vector.y
    }
    
    public static let zero: Point = Point(x: 0, y: 0)
    
    public func up() -> Point { Point(x, y-1) }
    public func down() -> Point { Point(x, y+1) }
    public func left() -> Point { Point(x-1, y) }
    public func right() -> Point { Point(x+1, y) }
    
    public var description: String { "(\(x),\(y))" }
}

extension Point: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x):\(y))"
    }
}

extension Point {
    public func angle(to point: Point, _ startAngle: Double = 0) -> Double {
        let dx = point.x - x
        let dy = point.y - y
        let angle = atan2(Double(dy), Double(dx)) + .pi / 2
        return (angle + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
    }
    
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
    
    public static func / (lhs: Point, rhs: Int) -> Point {
        return Point(x: lhs.x / rhs, y: lhs.y / rhs)
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
    
    public func add(direction: Direction, distance: Int = 1) -> Point {
        self + direction.point * distance
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
    
    public func directionTo(_ point: Point) -> Direction {
        if x < point.x { return .right }
        if x > point.x { return .left }
        if y < point.y { return .down }
        return .up
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
    
    func cardinalNeighbors<T>(in grid: Grid<T>, matching: [T]) -> Set<Point> {
        var neighbors = cardinalNeighbors(max: grid.bottomRight)
        
        for n in neighbors {
            if !matching.contains(grid[n]) {
                neighbors.remove(n)
            }
        }
        
        return neighbors
    }
    
    func isCardinalNeighbor(of point: Point) -> Bool {
        cardinalNeighbors().contains(point)
    }
    
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
    
    func extremeNeighbors(min minPoint: Point = .zero, max maxPoint: Point? = nil, size: Int) -> Set<Point> {
        var results = Set<Point>()
        
        for x in (max(minPoint.x, x - size)...min(x + size, maxPoint?.x ?? x + size)) {
            for y in (max(minPoint.y, y - size)...min(y + size, maxPoint?.y ?? y + size)) {
                results.insert(Point(x, y))
            }
        }
        
        return results
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
    
    func direction(from point: Point) -> Direction {
        if y == point.y {
            if x > point.x {
                return .right
            } else {
                return .left
            }
        } else {
            if y > point.y {
                return .down
            } else {
                return .up
            }
        }
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

public enum CompassDirection: Int, CaseIterable {
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
    
    var point: Point {
        switch self {
        case .n: return Point(0, -1)
        case .w: return Point(-1, 0)
        case .e: return Point(1, 0)
        case .s: return Point(0, 1)
        }
    }
    
    var opposite: CompassDirection {
        switch self {
        case .n: return .s
        case .s: return .n
        case .e: return .w
        case .w: return .e
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
    
    public func rotateLeft() -> Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .right: return .up
        case .left: return .down
        }
    }
    
    public func rotateRight() -> Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .right: return .down
        case .left: return .up
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
    
    public var inverse: Direction {
        opposite
    }
    
    // Used when you want to follow the outer edge of an area of tiles in a grid
    public var emptyEdge: Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }
}

public enum MovementDirection: Int {
    case left, right, straight
}

public extension Point {
    /*
     - A line is defined as y = mx + b OR y = slope * x + y-intercept
     - Slope = rise over run = dy / dx = height / distance
     - Y-intercept is where the line crosses the Y axis, where X = 0
     
     let a1 = Point(1,1)
     let a2 = Point(3,3)
     let b1 = Point(1,3)
     let b2 = Point(3,1)
     let slopeA = slope(p1: a1, p2: a2)
     let slopeB = slope(p1: b1, p2: b2)
     let yIntA = yIntercept(a1, slopeA)
     let yIntB = yIntercept(b1, slopeB)
     let result = lineIntersect(slopeA, yIntA, slopeB, yIntB)
     */
    static func slope(p1: Point, p2: Point) -> Double {
        // dy/dx
        // (y2 - y1) / (x2 - x1)
        return Double(p2.y - p1.y) / Double(p2.x - p1.x)
    }
    
    static func yIntercept(p1: Point, slope: Double) -> Double {
        // y = mx + b
        // b = y - mx
        // b = P1[1] - slope * P1[0]
        return Double(p1.y) - slope * Double(p1.x)
    }
    
    static func lineIntersect(m1: Double, b1: Double, m2: Double, b2: Double) -> (Double, Double)? {
        guard m1 != m2 else { return nil }
        // y = mx + b
        // Set both lines equal to find the intersection point in the x direction
        // m1 * x + b1 = m2 * x + b2
        // m1 * x - m2 * x = b2 - b1
        // x * (m1 - m2) = b2 - b1
        // x = (b2 - b1) / (m1 - m2)
        let x = (b2 - b1) / (m1 - m2)
        // Now solve for y -- use either line, because they are equal here
        // y = mx + b
        let y = m1 * x + b1
        return (x,y)
    }
    
    static func intersectionOfLines(a1: Point, a2: Point, b1: Point, b2: Point) -> (Double, Double)? {
        let m1 = Point.slope(p1: a1, p2: a2)
        let m2 = Point.slope(p1: b1, p2: b2)
        let y1 = Point.yIntercept(p1: a1, slope: m1)
        let y2 = Point.yIntercept(p1: b1, slope: m2)
//        print("A1",a1,"A2",a2,"B1",b1,"B2",b2)
//        print("M1",m1,"M2",m2,"Y1",y1,"Y2",y2)
        return Point.lineIntersect(m1: m1, b1: y1, m2: m2, b2: y2)
    }
}
