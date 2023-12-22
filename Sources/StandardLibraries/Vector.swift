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

extension Vector: CustomStringConvertible {
    public var description: String {
        "(\(x),\(y),\(z)"
    }
}

public extension Vector {
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func < (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    static func > (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    static func <= (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
    
    static func >= (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

public extension Vector {
    func cardinalNeighbours(_ allowNegative: Bool = false, max: Vector? = nil) -> Set<Vector> {
        Set(
            Vector.cardinalNeighbours.map({ $0 + self })
                .filter({ allowNegative || $0.x >= 0 && $0.y >= 0 && $0.z >= 0 })
                .filter({ max == nil || $0.x < max!.x && $0.y < max!.y && $0.z < max!.z })
        )
    }
    
    enum Direction {
        public static let up = Vector(x: 0,y: 1,z: 0)
        public static let down = Vector(x: 0,y: -1,z: 0)
        public static let left = Vector(x: -1,y: 0,z: 0)
        public static let right = Vector(x: 1,y: 0,z: 0)
        public static let forwards = Vector(x: 0,y: 0,z: 1)
        public static let backwards = Vector(x: 0,y: 0,z: -1)
        public static let all = [up, down, left, right, forwards, backwards]
    }
    
    static let zero = Vector(x: 0, y: 0, z: 0)
    
    static var cardinalNeighbours: Set<Vector> = {
        Set(Direction.all)
    }()
    
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
    
    // Manhattan distance
    func manhattanDistance(to: Vector) -> Int {
        return abs(x - to.x) + abs(y - to.y) + abs(z - to.z)
    }
    
    func distance(to: Vector) -> Double {
        sqrt(pow(Double(x - to.x), 2) + pow(Double(y - to.y), 2) + pow(Double(z - to.z), 2))
    }
}

public extension Collection where Element == Vector {
    func minMax() -> (Vector, Vector) {
        var minX = Int.max, minY = Int.max, minZ = Int.max
        var maxX = Int.min, maxY = Int.min, maxZ = Int.min
        
        self.forEach {
            minX = Swift.min(minX, $0.x)
            minY = Swift.min(minY, $0.y)
            minZ = Swift.min(minZ, $0.z)
            maxX = Swift.max(maxX, $0.x)
            maxY = Swift.max(maxY, $0.y)
            maxZ = Swift.max(maxZ, $0.z)
        }
        
        return (Vector(x: minX, y: minY, z: minZ), Vector(x: maxX, y: maxY, z: maxZ))
    }
}

public extension Collection where Element == Point {
    func minMax() -> (Point, Point) {
        var minX = Int.max, minY = Int.max
        var maxX = Int.min, maxY = Int.min
        
        self.forEach {
            minX = Swift.min(minX, $0.x)
            minY = Swift.min(minY, $0.y)
            maxX = Swift.max(maxX, $0.x)
            maxY = Swift.max(maxY, $0.y)
        }
        
        return (Point(x: minX, y: minY), Point(x: maxX, y: maxY))
    }
}

// MARK: - 3D
public extension Vector {
    func rotateX() -> Vector {
        var zMultiplier = 1
        var yMultiplier = 1
        if z >= 0 && y >= 0 {
            yMultiplier = -1
        } else if z >= 0 && y < 0 {
            zMultiplier = -1
            yMultiplier = -1
        } else if z < 0 && y < 0 {
            zMultiplier = -1
        }
        return Vector(
            x: x,
            y: abs(z) * yMultiplier,
            z: abs(y) * zMultiplier
        )
    }
    
    func rotateY() -> Vector {
        var xMultiplier = 1
        var zMultiplier = 1
        if x >= 0 && z >= 0 {
            zMultiplier = -1
        } else if x >= 0 && z < 0 {
            xMultiplier = -1
            zMultiplier = -1
        } else if x < 0 && z < 0 {
            xMultiplier = -1
        }
        return Vector(
            x: abs(z) * xMultiplier,
            y: y,
            z: abs(x) * zMultiplier
        )
    }
    
    func rotateZ() -> Vector {
        var xMultiplier = 1
        var yMultiplier = 1
        if x >= 0 && y >= 0 {
            yMultiplier = -1
        } else if x >= 0 && y < 0 {
            xMultiplier = -1
            yMultiplier = -1
        } else if x < 0 && y < 0 {
            xMultiplier = -1
        }
        return Vector(
            x: abs(y) * xMultiplier,
            y: abs(x) * yMultiplier,
            z: z
        )
    }
    /* https://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
    func rotateAroundX(_ angle: Double = 90) -> Vector {
        let sinAngle = sin(angle)
        let cosAngle = cos(angle)
        return Vector(
            x: x,
            y: Int(round(Double(y) * cosAngle - Double(z) * sinAngle)),
            z: Int(round(Double(y) * sinAngle + Double(z) * cosAngle))
        )
    }
    
    func rotateAroundY(_ angle: Double = 90) -> Vector {
        let sinAngle = sin(angle)
        let cosAngle = cos(angle)
        return Vector(
            x: Int(round(Double(z) * sinAngle + Double(x) * cosAngle)),
            y: y,
            z: Int(round(Double(z) * cosAngle - Double(x) * sinAngle))
        )
    }
    
    func rotateAroundZ(_ angle: Double = 90) -> Vector {
        let sinAngle = sin(angle)
        let cosAngle = cos(angle)
        return Vector(
            x: Int(round(Double(x) * cosAngle - Double(y) * sinAngle)),
            y: Int(round(Double(x) * sinAngle + Double(y) * cosAngle)),
            z: z
        )
    }
     */
}
