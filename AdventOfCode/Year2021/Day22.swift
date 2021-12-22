import Foundation
import StandardLibraries
import CryptoKit

public struct Day22 {
    public init() {}
        
    public struct Cube: Hashable {
        public let min: Vector
        public let max: Vector
        
        public var dx: Int { max.x - min.x }
        public var dy: Int { max.y - min.y }
        public var dz: Int { max.z - min.z }
        
        public func overlapping(with other: Cube) -> Bool {
            let a = (
                (min.x < other.min.x + other.dx) &&
                (min.y < other.min.y + other.dy) &&
                (other.min.x < min.x + dx) &&
                (other.min.y < min.y + dy)
            )
            let b = (
                (min.x < other.min.x + other.dx) &&
                (min.z < other.min.z + other.dz) &&
                (other.min.x < min.x + dx) &&
                (other.min.z < min.z + dz)
            )
            // exit early if possible
            if a && b { return true }
            
            let c = (
                (min.z < other.min.z + other.dz) &&
                (min.y < other.min.y + other.dy) &&
                (other.min.z < min.z + dz) &&
                (other.min.y < min.y + dy)
            )
            
            return (b && c) || (a && c)
        }
        
        public var isEmpty: Bool {
            self == .zero
        }
        
        public var area: Int {
            (max.x - min.x) * (max.y - min.y) * (max.z - min.z)
        }
        
        public func contains(_ other: Cube) -> Bool {
            (min.x <= other.min.x && min.x + dx >= other.max.x) &&
            (min.y <= other.min.y && min.y + dy >= other.max.y) &&
            (min.z <= other.min.z && min.z + dz >= other.max.z)
        }
        
        public func disect(with other: Cube) -> [Cube] {
            var spares = [Cube]()
            
            print("==================================================")
            print("Disecting:")
            print("Cube:", "x: \(min.x) -> \(max.x)", "y: \(min.y) -> \(max.y)", "z: \(min.z) -> \(max.z)")
            print("other:", "x: \(other.min.x) -> \(other.max.x)", "y: \(other.min.y) -> \(other.max.y)", "z: \(other.min.z) -> \(other.max.z)")
            print("--------------------------------------------------")
            
            var x = [Int]()
            var y = [Int]()
            var z = [Int]()
            
            if min.x < other.min.x {
                x.append(min.x)
                x.append(other.min.x)
            } else if min.x > other.min.x {
                x.append(other.min.x)
                x.append(min.x)
            } else {
                x.append(min.x)
            }

            if max.x < other.max.x {
                x.append(max.x)
                x.append(other.max.x)
            } else if max.x > other.max.x {
                x.append(other.max.x)
                x.append(max.x)
            } else {
                x.append(max.x)
            }
            

            if min.y < other.min.y {
                y.append(min.y)
                y.append(other.min.y)
            } else if min.y > other.min.y {
                y.append(other.min.y)
                y.append(min.y)
            } else {
                y.append(min.y)
            }
            
            if max.y < other.max.y {
                y.append(max.y)
                y.append(other.max.y)
            } else if max.y > other.max.y {
                y.append(other.max.y)
                y.append(max.y)
            } else {
                y.append(max.y)
            }
            

            if min.z < other.min.z {
                z.append(min.z)
                z.append(other.min.z)
            } else if min.z > other.min.z {
                z.append(other.min.z)
                z.append(min.z)
            } else {
                z.append(min.z)
            }
            
            if max.z < other.max.z {
                z.append(max.z)
                z.append(other.max.z)
            } else if max.z > other.max.z {
                z.append(other.max.z)
                z.append(max.z)
            } else {
                z.append(max.z)
            }
            
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
                            spares.append(cube)
                            print("spare part:", "x: \(cube.min.x) -> \(cube.max.x)", "y: \(cube.min.y) -> \(cube.max.y)", "z: \(cube.min.z) -> \(cube.max.z)")
                        } else {
                            print("contains:", "x: \(cube.min.x) -> \(cube.max.x)", "y: \(cube.min.y) -> \(cube.max.y)", "z: \(cube.min.z) -> \(cube.max.z)")
                        }
                    }
                }
            }
            
            
            return spares
        }
        
        public static let zero = Cube(min: .zero, max: .zero)
    }
    
    public func part1(_ input: [String]) -> Int {
        var cubes = [Cube]()
        var i = 0
        for line in input {
            i += 1
            print(i)
            let state = line.hasPrefix("on") ? true : false
            
            let splits = line.split(separator: " ")[1].split(separator: ",").map { $0.dropFirst(2) }
            let x = splits[0].components(separatedBy: "..")
            let y = splits[1].components(separatedBy: "..")
            let z = splits[2].components(separatedBy: "..")
            
            let minX = min(Int(String(x[0]))!, Int(String(x[1]))!)
            let maxX = max(Int(String(x[0]))!, Int(String(x[1]))!)
            let minY = min(Int(String(y[0]))!, Int(String(y[1]))!)
            let maxY = max(Int(String(y[0]))!, Int(String(y[1]))!)
            let minZ = min(Int(String(z[0]))!, Int(String(z[1]))!)
            let maxZ = max(Int(String(z[0]))!, Int(String(z[1]))!)
            
            let cube = Cube(min: Vector(x: minX,y: minY,z: minZ), max: Vector(x: maxX,y: maxY,z: maxZ))
            var newCubes = [Cube]()

            for c1 in cubes {
                if cube.contains(c1) {
                    print("==================================================")
                    print("Cube contains existing cube:")
                    print("Cube:", "x: \(cube.min.x) -> \(cube.max.x)", "y: \(cube.min.y) -> \(cube.max.y)", "z: \(cube.min.z) -> \(cube.max.z)")
                    print("Removing:", "x: \(c1.min.x) -> \(c1.max.x)", "y: \(c1.min.y) -> \(c1.max.y)", "z: \(c1.min.z) -> \(c1.max.z)")
//                    toRemove.append(c1)
                } else if cube.overlapping(with: c1) {
                    let nonOverlapping = cube.disect(with: c1)
                    newCubes.append(contentsOf: nonOverlapping)
                }
            }
            
            if state {
                newCubes.append(cube)
            }

            print("updated:", newCubes.count)
            cubes = newCubes
        }
        
        print("Calculating answer:", cubes.count)
        return cubes.reduce(0, { $0 + $1.area })
    }
    
    public func part2(_ input: [String]) -> Int {
        var cube = [Vector: Bool]()
        var i = 0
        for line in input {
            i += 1
            print(i)
            let state = line.hasPrefix("on") ? true : false
            
            let splits = line.split(separator: " ")[1].split(separator: ",").map { $0.dropFirst(2) }
            let x = splits[0].components(separatedBy: "..")
            let y = splits[1].components(separatedBy: "..")
            let z = splits[2].components(separatedBy: "..")
            
            let minX = min(Int(String(x[0]))!, Int(String(x[1]))!)
            let maxX = max(Int(String(x[0]))!, Int(String(x[1]))!)
            let minY = min(Int(String(y[0]))!, Int(String(y[1]))!)
            let maxY = max(Int(String(y[0]))!, Int(String(y[1]))!)
            let minZ = min(Int(String(z[0]))!, Int(String(z[1]))!)
            let maxZ = max(Int(String(z[0]))!, Int(String(z[1]))!)
            
            for x in (minX...maxX) {
                for y in (minY...maxY) {
                    for z in (minZ...maxZ) {
                        let vector = Vector(x: x,y: y,z: z)
                        if state {
                            cube[vector] = state
                        } else if cube[vector] != nil {
                            cube.removeValue(forKey: vector)
                        }
                    }
                }
            }
        }
        return cube.values.filter { $0 == true }.count
    }
}
