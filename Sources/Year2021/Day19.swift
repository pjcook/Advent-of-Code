import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public typealias Scanners = [Scanner]
    public typealias Face = [Vector]
    
    public struct Scanner: Hashable {
        public let id: String
        public let beacons: Face
        public init(id: String = UUID().uuidString, beacons: Face) {
            self.id = id
            self.beacons = beacons
        }
    }
    
    /*
     There are "Scanners" and "Beacons". The Vectors x,y,z coordinates of the beacons relative to the scanners are in the puzzle input. The scanners could be facing in any direction with a different rotation of 90 degree rotations from each other. Scanners can only see beacons up to 1000 units away from them. You need to plot all the beacons and create a giant cube from them by matching at least 12 points for each scanner. Then orientate each scanner with scanner 0.
     
     Then count how many unique beacons there are.
     */
    public func part1(_ input: [String]) -> Int {
        let (_, allBeacons) = solve(input)
        return allBeacons.count
    }
    
    public func part2(_ input: [String]) -> Int {
        var (scannerPositions, _) = solve(input)
        var position = scannerPositions.removeLast()
        var distance = 0
        while !scannerPositions.isEmpty {
            for next in scannerPositions {
                let nextDistance = position.manhattanDistance(to: next)
                if nextDistance > distance {
                    distance = nextDistance
                }
            }
            position = scannerPositions.removeLast()
        }
        return distance
    }
    
    /*
     • Convert the input into lists of beacons with relative scanner positions
     • Just pick the first scanner to be the primary and map every other scanner and beacon back to that
     • Loop through each scanner trying to see if you have enough info to match it up with the information you already know.
     • To match a scanner, loop over each beacon in the known list of beacons, calculate the vectors from that beacon to ALL other know beacons in any direction, then for each beacon in the next scanner, look at each beacon in turn for each potential orientation, and calculate the vectors from that beacon to every other beacon. Using Sets find the intersection of those two sets of vectors. If there are more than 6 matching vectors then you have found the correct orientation for the scanner. You can calculate the relative position of the scanner in relation to the original scanner by taking the first beacon position away from the beacon position on the scanner that you are checking against. You can then calculate the relative position for ALL beacons on that scanner by taking the scanner position away from each beacon position and adding those to the set of known beacons before moving on to the next scanner. Any additional known beacons help you solve subsequent scanners.
     */
    public func solve(_ input: [String]) -> ([Vector], Set<Vector>) {
        var scanners = parse(input)
        let primary = scanners.removeFirst()
        let primaryFace = primary.beacons
        
        var scannerPositions: [Vector] = [.zero]
        var knownBeacons = Set(primaryFace)

        while !scanners.isEmpty {
            let scanner = scanners.removeFirst()
            var matched = false

            // try to calculate position of the scanner
            outerloop: for b1 in knownBeacons {
                // You have to do this each time because the list of known beacons hopefully increases each time
                let primaryVectorSet = calculateVectors(b1, in: Array(knownBeacons))

                for transform in allTransforms {
                    let face = scanner.beacons.map { transform($0) }
                    for b2 in face {
                        let faceVectors = calculateVectors(b2, in: face)
                        if primaryVectorSet.intersection(faceVectors).count >= 6 {
                            let scannerPosition = b2 - b1
                            scannerPositions.append(scannerPosition)
                            
                            // add translated beacons to allBeacons list
                            for beacon in face {
                                knownBeacons.insert(beacon - scannerPosition)
                            }

                            matched = true
                            break outerloop
                        }
                    }
                }
            }
            
            // If scanner was not matched append to the end of the list to check again later.
            if !matched {
                scanners.append(scanner)
            }
        }
        
        return (scannerPositions, knownBeacons)
    }
    
    public var allTransforms: [(Vector) -> Vector] {
        [
            { Vector(x:  $0.x, y:  $0.y, z:  $0.z) },
            { Vector(x:  $0.x, y:  $0.z, z: -$0.y) },
            { Vector(x:  $0.x, y: -$0.y, z: -$0.z) },
            { Vector(x:  $0.x, y: -$0.z, z:  $0.y) },
            { Vector(x:  $0.y, y:  $0.x, z: -$0.z) },
            { Vector(x:  $0.y, y:  $0.z, z:  $0.x) },
            { Vector(x:  $0.y, y: -$0.x, z:  $0.z) },
            { Vector(x:  $0.y, y: -$0.z, z: -$0.x) },
            { Vector(x:  $0.z, y:  $0.x, z:  $0.y) },
            { Vector(x:  $0.z, y:  $0.y, z: -$0.x) },
            { Vector(x:  $0.z, y: -$0.x, z: -$0.y) },
            { Vector(x:  $0.z, y: -$0.y, z:  $0.x) },
            { Vector(x: -$0.x, y:  $0.y, z: -$0.z) },
            { Vector(x: -$0.x, y:  $0.z, z:  $0.y) },
            { Vector(x: -$0.x, y: -$0.y, z:  $0.z) },
            { Vector(x: -$0.x, y: -$0.z, z: -$0.y) },
            { Vector(x: -$0.y, y:  $0.x, z:  $0.z) },
            { Vector(x: -$0.y, y:  $0.z, z: -$0.x) },
            { Vector(x: -$0.y, y: -$0.x, z: -$0.z) },
            { Vector(x: -$0.y, y: -$0.z, z:  $0.x) },
            { Vector(x: -$0.z, y:  $0.x, z: -$0.y) },
            { Vector(x: -$0.z, y:  $0.y, z:  $0.x) },
            { Vector(x: -$0.z, y: -$0.x, z:  $0.y) },
            { Vector(x: -$0.z, y: -$0.y, z: -$0.x) },
        ]
    }
    
    public func calculateVectors(_ beacon: Vector, in face: Face) -> Set<Vector> {
        var vectors = Set<Vector>()
        
        for b1 in face {
            if beacon != b1 {
                vectors.insert(b1 - beacon)
            }
        }
        
        return vectors
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
