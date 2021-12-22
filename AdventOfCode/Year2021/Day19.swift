import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public typealias Scanners = [Scanner]
    public typealias Face = [Vector]
    public typealias FaceDistances = Set<Vector>
    
    public struct Scanner: Hashable {
        public let id: String
        public let faces: [Face]
        public var position: Vector?
        public init(id: String = UUID().uuidString, beacons: Face) {
            self.id = id
            self.faces = Self.calculateFaces(beacons)
        }
        
        public static func calculateFaces(_ beacons: Face) -> [Face] {
            var beacons = beacons
            var faces = [Face]()
            
            for _ in (0..<4) {
                beacons = beacons.map { $0.rotateX() }
                faces.append(beacons)

                for _ in (0..<4) {
                    beacons = beacons.map { $0.rotateY() }
                    faces.append(beacons)

                    for _ in (0..<4) {
                        beacons = beacons.map { $0.rotateZ() }
                        faces.append(beacons)

                    }
                }
            }
            
            return faces
        }
        
        private func duplicate(with beacons: [Vector]) -> Scanner {
            Scanner(id: id, beacons: beacons)
        }
    }
    
    /*
     There are "Scanners" and "Beacons". The Vectors x,y,z coordinates of the beacons relative to the scanners are in the puzzle input. The scanners could be facing in any direction with a different rotation of 90 degree rotations from each other. Scanners can only see beacons up to 1000 units away from them. You need to plot all the beacons and create a giant cube from them by matching at least 12 points for each scanner. Then orientate each scanner with scanner 0.
     
     Then count how many unique beacons there are.
     */
    public func part1(_ input: [String]) -> Int {
        var scanners = parse(input)
        let primary = scanners.removeFirst()
        let primaryFace = primary.faces.first!
        let primaryFaceVectors = calculateVectors(primaryFace)

        var matched = [primaryFace]
        
        for scanner in scanners {
            // for each scanner, find the matching FACE
            if let face = findMatchingFace(primaryFaceVectors, scanner: scanner) {
//                draw(face)
                // Found a face
                matched.append(face)
                
                // Now align it
                alignFaces(primaryFace, face)
            } else {
                print("fail", primaryFace.minMax())
            }
        }
        
        return 0
    }
    
    public func alignFaces(_ f1: Face, _ f2: Face) {
        var f1 = f1
        var f2 = f2
        
        // attempt to align points
        outerloop: while !f1.isEmpty {
            let f1MinMax = f1.minMax()            
            var f1b = f1.map { $0 - (.zero - f1MinMax.1) }.sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y })
            for p1 in f1b {
                var f2c = f2
                while !f2c.isEmpty {
                    let f2MinMax = f2c.minMax()
                    var f2b = f2c.map { $0 - (.zero - f2MinMax.1) }.sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y })
                    for p2 in f2b {
                        if p1 == p2 {
                            
                            break outerloop
                        }
                    }
                    _ = f2c.removeFirst()
                }
            }
            _ = f1.removeFirst()
        }
    }
    public func findMatchingFace(_ primaryVectors: FaceDistances, scanner: Scanner) -> Face? {
        for face in scanner.faces {
            let vectors = calculateVectors(face)
            if match(primaryVectors, vectors) {
                return face
            }
        }
        return nil
    }
    
    public func match(_ vectors1: FaceDistances, _ vectors2: FaceDistances) -> Bool {
        return vectors1.intersection(vectors2).count >= 3
    }
    
    public func calculateVectors(_ face: Face) -> FaceDistances {
        var distances = FaceDistances()
        var face = face.sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y }).sorted(by: { $0.z < $1.z })
        while !face.isEmpty {
            let p1 = face.removeLast()
            for p2 in face {
                distances.insert(p2 - p1)
            }
        }
        
        return distances
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
    
    public func draw(_ beacons: Face) {
        let (minCoords, maxCoords) = beacons.minMax()
        let dx = maxCoords.x - minCoords.x
        let dy = maxCoords.y - minCoords.y
        let d = max(dx, dy)+2
        let items = Set(beacons.map({ Point($0.x, $0.y) }))
        draw(items, min: Point(-d, -d), max: Point(d,d))
    }
    
    public func draw(_ tiles: Set<Point>, min: Point, max: Point) {
        for y in (min.y...max.y) {
            var line = ""
            for x in (min.x...max.x) {
                if y == 0 && x == 0 {
                    line.append("🔴")
                } else {
                    line.append(tiles.contains(Point(x: x, y: y)) ? "⚪️" : "⚫️")
                }
            }
            print(line)
        }
        print()
    }
}
