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
    static let adjacent: [Vector] = [
        Vector(x: -1, y: -1, z: -1),
        Vector(x: 0, y: -1, z: -1),
        Vector(x: 1, y: -1, z: -1),
        Vector(x: -1, y: 0, z: -1),
        Vector(x: 1, y: 0, z: -1),
        Vector(x: -1, y: 1, z: -1),
        Vector(x: 0, y: 1, z: -1),
        Vector(x: 1, y: 1, z: -1),
        Vector(x: 0, y: 0, z: -1),

        Vector(x: -1, y: -1, z: 0),
        Vector(x: 0, y: -1, z: 0),
        Vector(x: 1, y: -1, z: 0),
        Vector(x: -1, y: 0, z: 0),
        Vector(x: 1, y: 0, z: 0),
        Vector(x: -1, y: 1, z: 0),
        Vector(x: 0, y: 1, z: 0),
        Vector(x: 1, y: 1, z: 0),

        Vector(x: -1, y: -1, z: 1),
        Vector(x: 0, y: -1, z: 1),
        Vector(x: 1, y: -1, z: 1),
        Vector(x: -1, y: 0, z: 1),
        Vector(x: 1, y: 0, z: 1),
        Vector(x: -1, y: 1, z: 1),
        Vector(x: 0, y: 1, z: 1),
        Vector(x: 1, y: 1, z: 1),
        Vector(x: 0, y: 0, z: 1),
    ]
}
