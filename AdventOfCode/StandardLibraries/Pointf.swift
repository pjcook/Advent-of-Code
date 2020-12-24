import Foundation

public struct Pointf: Hashable {
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public static let zero: Pointf = Pointf(x: 0, y: 0)
}

extension Pointf {
    public var manhattanDistance: Float {
        abs(x) + abs(y)
    }
    
    public func isValid(max: Pointf) -> Bool {
        return x >= 0 && x < max.x && y >= 0 && y < max.y
    }
    
    public static func + (lhs: Pointf, rhs: Pointf) -> Pointf {
        return Pointf(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
        
    public static func - (lhs: Pointf, rhs: Pointf) -> Pointf {
        return Pointf(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func / (lhs: Pointf, rhs: Pointf) -> Pointf {
        return Pointf(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    public static func * (lhs: Pointf, rhs: Pointf) -> Pointf {
        return Pointf(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    public static func * (lhs: Pointf, rhs: Float) -> Pointf {
        return Pointf(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    public func add(direction: Direction, distance: Float) -> Pointf {
        switch direction {
        case .n: return Pointf(x: x, y: y + distance)
        case .s: return Pointf(x: x, y: y - distance)
        case .e: return Pointf(x: x + distance, y: y)
        case .w: return Pointf(x: x - distance, y: y)
        }
    }
    
    public func rotateLeft(angle: Float) -> Pointf {
        switch angle / 90 {
        case 1: return Pointf(x: -y, y: x)
        case 2: return Pointf(x: -x, y: -y)
        case 3: return Pointf(x: y, y: -x)
        default: return self
        }
    }
    
    public func rotateRight(angle: Float) -> Pointf {
        switch angle / 90 {
        case 1: return Pointf(x: y, y: -x)
        case 2: return Pointf(x: -x, y: -y)
        case 3: return Pointf(x: -y, y: x)
        default: return self
        }
    }
    
    public func rotateLeft(times: Float) -> Pointf {
        switch times {
        case 1: return Pointf(x: -y, y: x)
        case 2: return Pointf(x: -x, y: -y)
        case 3: return Pointf(x: y, y: -x)
        default: return self
        }
    }
    
    public func rotateRight(times: Float) -> Pointf {
        switch times {
        case 1: return Pointf(x: y, y: -x)
        case 2: return Pointf(x: -x, y: -y)
        case 3: return Pointf(x: -y, y: x)
        default: return self
        }
    }
}

public extension Pointf {
    static var adjacent: Set<Pointf> = {
        var items = Set<Pointf>()
        for y in (-1...1) {
            for x in (-1...1) {
                items.insert(Pointf(x: Float(x), y: Float(y)))
            }
        }
        items.remove(.zero)
        return items
    }()
}
