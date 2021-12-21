import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public typealias Scanners = [Scanner]
    public typealias Face = [Vector]
    public typealias FaceDistances = Set<Double>
    
    public struct Scanner: Hashable {
        public let id: String
        public let faces: [Face]
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
                draw(face)
                matched.append(face)
            } else {
                print("fail", primaryFace.minMax())
//                print("fail", matched.count)
            }
        }
        
        return 0
    }
    
    public func findMatchingFace(_ primaryVectors: FaceDistances, scanner: Scanner) -> Face? {
        for face in scanner.faces {
//            draw(face)
            let vectors = calculateVectors(face)
            if match(primaryVectors, vectors) {
                return face
            }
        }
        return nil
    }
    
    public func match(_ vectors1: FaceDistances, _ vectors2: FaceDistances) -> Bool {
        var a = 0
        var b = 0
//        while a < vectors1.count {
//            let v1 = vectors1[a]
//            
//            while b < vectors2.count {
//                let v2 = vectors2[b]
//                if v1 == v2 { // find first match of sequence
//                    // check for sequence
//                    var a2 = a + 1
//                    var b2 = b + 1
//                    var count = 1
//                    while b2 < vectors2.count {
//                        if vectors1[a2] == vectors2[b2] {
//                            count += 1
//                            a2 += 1
//                            b2 = b + count
//                        }
//                        b2 += 1
//                    }
//                        
//                    if count >= 12 || count == vectors2.count { return true }
//                }
//                b += 1
//            }
//            a += 1
//        }
        return false
    }
    
    public func calculateVectors(_ face: Face) -> FaceDistances {
        var newFace = FaceDistances()
        
        
        
//        var items = Array(face.map({ Point($0.x, $0.y) }).sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y }))
//        var previous = items.removeFirst()
//        let (minPoint, maxPoint) = items.minMax()
//        let transpose = .zero - minPoint
//
//        // transpose points so all points should be in the positive
//        items = items.map { $0 + transpose }
//
//        // The origin (start point) is now zero
//        previous = .zero
//
//        while !items.isEmpty {
//            let next = items.removeFirst()
//            newFace.append(next - previous)
//            previous = next
//        }
        
        return newFace
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
