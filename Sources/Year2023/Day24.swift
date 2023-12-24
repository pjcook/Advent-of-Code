import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    // https://www.youtube.com/watch?v=guOyA7Ijqgk
    public func part1(_ input: [String], minValue: Double, maxValue: Double) -> Int {
        let hailstones = parse(input)
        var total = 0
        for (i, hs1) in hailstones.enumerated() {
            for hs2 in hailstones[(i+1)...] {
                let (a1, b1, c1) = (hs1.a, hs1.b, hs1.c)
                let (a2, b2, c2) = (hs2.a, hs2.b, hs2.c)
                if a1 * b2 == b1 * a2 {
//                    print(hs1, hs2)
                    continue    // Skip parallel lines
                }
                let x = (c1 * b2 - c2 * b1) / (a1 * b2 - a2 * b1)
                let y = (c2 * a1 - c1 * a2) / (a1 * b2 - a2 * b1)
//                print(x,y)
                
                guard (minValue..<maxValue).contains(x), (minValue..<maxValue).contains(y) else { continue }
                let options: [Hailstone] = [hs1, hs2]
                var isValid = true
                for hs in options {
                    isValid = isValid && (x - hs.x) * hs.vx >= 0 && (y - hs.y) * hs.vy >= 0
                }
                if isValid {
                    total += 1
                }
            }
        }
        
        return total
    }
        
//    public func part1b(_ input: [String], minValue: Int, maxValue: Int) -> Int {
//        let hailstones = parse(input)
//        var seen = Set<CacheKey>()
//        var intersections = [(Point, Point, Point)]()
//        
//        for hailstone in hailstones {
//            for hs in hailstones {
//                guard hailstone != hs else { continue }
//                let cacheKey = CacheKey(p1: hailstone.position, p2: hs.position)
//                guard !seen.contains(cacheKey) else { continue }
//                seen.insert(cacheKey)
//                seen.insert(cacheKey.reversed())
//                
//                let a1 = Point(hailstone.position.x, hailstone.position.y)
//                let v1 = Point(hailstone.velocity.x, hailstone.velocity.y)
//                let a2 = a1 + v1
//                let b1 = Point(hs.position.x, hs.position.y)
//                let v2 = Point(hs.velocity.x, hs.velocity.y)
//                let b2 = b1 + v2
////                print(hailstone.position, hs.position)
//                if let (x,y) = Point.intersectionOfLines(a1: a1, a2: a2, b1: b1, b2: b2) {
//                    intersections.append((a1, b1, Point(Int(x), Int(y))))
//                }
//            }
//        }
//        
//        var count = 0
//        var points = Set<Point>()
//        intersections
//            .filter {
////                print($0.0, $0.1, $0.2)
//                return (minValue..<maxValue).contains($0.2.x) && (minValue..<maxValue).contains($0.2.y)
//            }
//            .forEach {
////                print($0.0, $0.1, $0.2)
//                points.insert($0.0)
//                points.insert($0.1)
//            }
//        
////        print()
//        points.forEach { point in
////            print(point)
//            let hailstone = hailstones.first {
//                $0.position.x == point.x && $0.position.y == point.y
//            }!
//            let first = intersections
//                .filter {
//                    $0.0 == point || $0.1 == point
//                }
//                .sorted {
//                    switch (hailstone.velocity.x < 0, hailstone.velocity.y < 0) {
//                    case (true,true): $0.2.x > $1.2.x && $0.2.y > $1.2.y
//                    case (true,false): $0.2.x > $1.2.x && $0.2.y < $1.2.y
//                    case (false,true): $0.2.x < $1.2.x && $0.2.y > $1.2.y
//                    case (false,false): $0.2.x < $1.2.x && $0.2.y < $1.2.y
//                    }
//                }
//            print()
//            print(hailstone.position, hailstone.velocity)
//            first.forEach {
//                print("--- :", $0.0, $0.1, $0.2)
//            }
//            
//            let first2 = first.first
//            if let first2, (minValue...maxValue).contains(first2.2.x) && (minValue...maxValue).contains(first2.2.y) {
//                count += 1
//                print("in :", hailstone.position, hailstone.velocity)
//            } else {
//                print("out:", hailstone.position, hailstone.velocity)
//            }
//        }
//
//        return count
//    }
    
    public func part2(_ input: [String]) -> Int {
        let hailstones = parse(input)
        
        return 1
    }
    
    struct CacheKey: Hashable {
        let p1: Vector
        let p2: Vector
        
        func reversed() -> CacheKey {
            CacheKey(p1: p2, p2: p1)
        }
    }
    
    struct Hailstone: Hashable, CustomStringConvertible {
        let x: Double
        let y: Double
        let z: Double
        let vx: Double
        let vy: Double
        let vz: Double
        let a: Double
        let b: Double
        let c: Double
        
        init(_ x: Double, _ y: Double, _ z: Double, _ vx: Double, _ vy: Double, _ vz: Double) {
            self.x = x
            self.y = y
            self.z = z
            self.vx = vx
            self.vy = vy
            self.vz = vz
            self.a = vy
            self.b = -vx
            self.c = Double(vy * x) - Double(vx * y)
        }
        
        var description: String {
            "(\(x),\(y))"
        }
    }
}

extension Day24 {
    // px py pz @ vx vy vz
    func parse(_ input: [String]) -> [Hailstone] {
        var hailstones = [Hailstone]()
        
        for line in input {
            let components = line
                .replacingOccurrences(of: " @ ", with: ",")
                .replacingOccurrences(of: " ", with: "")
                .components(separatedBy: ",").map { Double($0)! }
            hailstones.append(Hailstone(components[0], components[1], components[2], components[3], components[4], components[5]))
        }
        
        return hailstones
    }
}
