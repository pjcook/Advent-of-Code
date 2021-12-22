import Foundation

public struct Cube: Hashable {
    public let min: Vector
    public let max: Vector
    
    public init(min: Vector, max: Vector) {
        self.min = min
        self.max = max
    }
    
    public func overlapping(with other: Cube) -> Bool {
        return !(other.min.x > max.x || other.max.x < min.x ||
            other.min.y > max.y || other.max.y < min.y ||
            other.min.z > max.z || other.max.z < min.z
        )
    }
    
    public static let zero = Cube(min: .zero, max: .zero)

    public var isEmpty: Bool {
        self == .zero
    }
    
    public var area: Int {
        (max.x - min.x) * (max.y - min.y) * (max.z - min.z)
    }
    
    public func contains(_ other: Cube) -> Bool {
        (min.x <= other.min.x && max.x >= other.max.x) &&
        (min.y <= other.min.y && max.y >= other.max.y) &&
        (min.z <= other.min.z && max.z >= other.max.z)
    }
    
    public func dissect(with other: Cube) -> [Cube] {
        var spares = [Cube]()
        
        // Create spare cubes from any part of `other` that is outside of `self`
        
        var x = [Int]()
        var y = [Int]()
        var z = [Int]()
        
        // Find all the different values of X, Y, Z up to 4 of each
        func calcValues(a: Int, b: Int) -> [Int] {
            if a < b {  return [a,b] }
            else if a > b { return [b,a] }
            return [a]
        }
        
        x.append(contentsOf: calcValues(a: min.x, b: other.min.x))
        x.append(contentsOf: calcValues(a: max.x, b: other.max.x))
        y.append(contentsOf: calcValues(a: min.y, b: other.min.y))
        y.append(contentsOf: calcValues(a: max.y, b: other.max.y))
        z.append(contentsOf: calcValues(a: min.z, b: other.min.z))
        z.append(contentsOf: calcValues(a: max.z, b: other.max.z))
        
        // Step through each pair of values for X, Y, Z to cut off the bits outside `self`
        for xIndex in (1..<x.count) {
            let x1 = x[xIndex - 1]
            let x2 = x[xIndex]
            for yIndex in (1..<y.count) {
                let y1 = y[yIndex - 1]
                let y2 = y[yIndex]
                for zIndex in (1..<z.count) {
                    let z1 = z[zIndex - 1]
                    let z2 = z[zIndex]
                    let cube = Cube(min: Vector(x: x1, y: y1, z: z1), max: Vector(x: x2, y: y2, z: z2))
                    
                    if !contains(cube) && other.contains(cube) {
                        // Keep spare part
                        spares.append(cube)
                    }
                }
            }
        }
        
        return spares
    }
}
