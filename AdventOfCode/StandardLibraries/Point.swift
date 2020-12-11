import Foundation

public struct Point: Hashable {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static let zero: Point = Point(x: 0, y: 0)
}

public extension Point {
    func adjacent(_ position: Position, _ min: Point, _ max: Point) -> Point? {
        let point = self + position.point
        guard point.x >= min.x && point.x < max.x && point.y >= min.y && point.y < max.y else {
            return nil
        }
        return point
    }
    
    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

public enum Position {
    case tl, t, tr
    case l, m, r
    case bl, b, br
    
    var point: Point {
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
