import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public typealias Scanners = [Scanner]
    public typealias Distances = [VectorKey:Int]
    
    public struct VectorKey: Hashable {
        public let p1: Vector
        public let p2: Vector
        public init(_ p1: Vector, _ p2: Vector) {
            self.p1 = p1
            self.p2 = p2
        }
        
        public static func == (lhs: VectorKey, rhs: VectorKey) -> Bool {
            [lhs.p1, lhs.p2].contains(rhs.p1) && [lhs.p1, lhs.p2].contains(rhs.p2)
        }
    }
    
    public struct Scanner: Hashable {
        public let id: String
        public let beacons: [Vector]
        public let distances: Distances
        public init(id: String = UUID().uuidString, beacons: [Vector]) {
            var distances = Distances()
            var list = beacons
            while !list.isEmpty {
                let beacon = list.removeLast()
                for b in list {
                    distances[VectorKey(beacon,b)] = abs(beacon.distance(to: b))
                }
            }
            self.init(id: id, beacons: beacons, distances: distances)
        }
        
        public init(id: String, beacons: [Vector], distances: Distances) {
            self.id = id
            self.beacons = beacons
            self.distances = distances
        }
        
        public func translate(_ vector: Vector) -> Scanner {
            let translatedBeacons = beacons.map { $0 + vector }
            return Scanner(id: id, beacons: translatedBeacons, distances: distances)
        }
        
        public func rotateX() -> Scanner {
//            let (minCoord, _) = beacons.minMax()
//            let additive = Vector(x: 0, y: -1 * minCoord.y, z: -1 * minCoord.z)
//            let negative = Vector(x: 0, y: minCoord.z, z: minCoord.y)
            let translatedBeacons = beacons
//                .map { $0 + additive }
                .map { $0.rotateX() }
//                .map { $0 + negative }
            
            return Scanner(id: id, beacons: translatedBeacons, distances: distances)
        }
        
        public func rotateY() -> Scanner {
//            let (minCoord, _) = beacons.minMax()
//            let additive = Vector(x: -1 * minCoord.x, y: 0, z: -1 * minCoord.z)
//            let negative = Vector(x: minCoord.z, y: 0, z: minCoord.x)
            let translatedBeacons = beacons
//                .map { $0 + additive }
                .map { $0.rotateY() }
//                .map { $0 + negative }
            
            return Scanner(id: id, beacons: translatedBeacons, distances: distances)
        }
        
        public func rotateZ() -> Scanner {
//            let (minCoord, _) = beacons.minMax()
//            let additive = Vector(x: -1 * minCoord.x, y: -1 * minCoord.y, z: 0)
//            let negative = Vector(x: minCoord.y, y: minCoord.x, z: 0)
            let translatedBeacons = beacons
//                .map { $0 + additive }
                .map { $0.rotateZ() }
//                .map { $0 + negative }
            
            return Scanner(id: id, beacons: translatedBeacons, distances: distances)
        }
    }
    
    /*
     There are "Scanners" and "Beacons". The Vectors x,y,z coordinates of the beacons relative to the scanners are in the puzzle input. The scanners could be facing in any direction with a different rotation of 90 degree rotations from each other. Scanners can only see beacons up to 1000 units away from them. You need to plot all the beacons and create a giant cube from them by matching at least 12 points for each scanner. Then orientate each scanner with scanner 0.
     
     Then count how many unique beacons there are.
     */
    public func part1(_ input: [String]) -> Int {
        var scanners = parse(input)
        let scanner0 = scanners.removeFirst()

        for scanner in scanners {
            // Find beacon to match
            let (vectorA, vectorB) = findBeaconToMatch(scanner0.distances, scanner.distances)
            
            // Translate scanner beacon positions to scanner0 dXYZ
//            let translated = scanner.translate(vectorA + vectorB)
            
            // RotateTransform scanner and check if more than 12 beacon positions match
        }
        
        return 0
    }
    
    public func findBeaconToMatch(_ a: Distances, _ b: Distances) -> (VectorKey, VectorKey) {
        for item1 in a {
            for item2 in b {
                if item1.value == item2.value {
                    return (item1.key, item2.key)
                }
            }
        }
        abort()
    }
    
    public func part2(_ input: [String]) -> Int {
        return 0
    }
    
    public func parse(_ input: [String]) -> Scanners {
        var scanners = Scanners()
        var beacons = [Vector]()
        for i in (0..<input.count) {
            let line = input[i]
            if line.isEmpty {
                scanners.append(Scanner(beacons: beacons))
            } else if line.hasPrefix("--") {
                beacons = []
            } else {
                let components = line.split(separator: ",").map({ Int($0)! })
                beacons.append(Vector(x: components[0], y: components[1], z: components[2]))
            }
        }
        scanners.append(Scanner(beacons: beacons))
        return scanners
    }
}
