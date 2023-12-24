import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String], minValue: Int, maxValue: Int) -> Int {
        let hailstones = parse(input)
        var count = 0
        var seen = Set<CacheKey>()
        
        for hailstone in hailstones {
            for hs in hailstones {
                guard hailstone != hs else { continue }
                let cacheKey = CacheKey(p1: hailstone.position, p2: hs.position)
                guard !seen.contains(cacheKey) else { continue }
                seen.insert(cacheKey)
                seen.insert(cacheKey.reversed())
                
                let p1 = Point(hailstone.position.x, hailstone.position.y)
                let v1 = Point(hailstone.velocity.x, hailstone.velocity.y)
                let p2 = Point(hs.position.x, hs.position.y)
                let v2 = Point(hs.velocity.x, hs.velocity.y)
                let line1 = Line(p1: p1, p2: p1 + v1)
                let line2 = Line(p1: p2, p2: p2 + v2)
                if let (x, y) = intersectionOfLines(line1: line1, line2: line2) {
                    let p1min = p1 + (v1 * Point(minValue, minValue))
                    let p1max = p1 + (v1 * Point(maxValue, maxValue))
                    let p2min = p2 + (v2 * Point(minValue, minValue))
                    let p2max = p2 + (v2 * Point(maxValue, maxValue))
                    let intersection = Point(Int(x), Int(y))
                    if intersection.isInArea(p1: p1min, p2: p1max), intersection.isInArea(p1: p2min, p2: p2max) {
                        count += 1
                    }
                } else {
                    print(p1, p2, "never cross")
                }
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        1
    }
    
    struct CacheKey: Hashable {
        let p1: Vector
        let p2: Vector
        
        func reversed() -> CacheKey {
            CacheKey(p1: p2, p2: p1)
        }
    }
    
    struct Hailstone: Hashable {
        let position: Vector
        let velocity: Vector
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
                .components(separatedBy: ",").map { Int($0)! }
            let position = Vector(x: components[0], y: components[1], z: components[2])
            let velocity = Vector(x: components[3], y: components[4], z: components[5])
            hailstones.append(Hailstone(position: position, velocity: velocity))
        }
        
        return hailstones
    }
}
