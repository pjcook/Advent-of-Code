import Foundation

public struct Vector: Hashable {
    public let x: Int
    public let y: Int
    public let z: Int
    
    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public extension Vector {
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}

public extension Vector {
    static let zero = Vector(x: 0, y: 0, z: 0)
    
    static var adjacent: Set<Vector> = {
        var items = Set<Vector>()
            for z in (-1...1) {
                for y in (-1...1) {
                    for x in (-1...1) {
                        items.insert(Vector(x: x, y: y, z: z))
                    }
                }
            }
        items.remove(.zero)
        return items
    }()
}
