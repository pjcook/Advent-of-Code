import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String], minValue: Double, maxValue: Double) -> Int {
        let hailstones = parse(input)
        var total = 0
        for (i, hs1) in hailstones.enumerated() {
            for hs2 in hailstones[(i+1)...] {
                let (apx, apy, avx, avy) = (hs1.x, hs1.y, hs1.vx, hs1.vy)
                let (bpx, bpy, bvx, bvy) = (hs2.x, hs2.y, hs2.vx, hs2.vy)
                let m1 = avy / avx
                let m2 = bvy / bvx
                let c1 = apy - (m1 * apx)
                let c2 = bpy - (m2 * bpx)
                if m1 == m2 {
                    continue
                }
                let xPos = (c2 - c1) / (m1 - m2)
                let yPos = m1 * xPos + c1
                if (xPos < apx && avx > 0) || (xPos > apx && avx < 0) || (xPos < bpx && bvx > 0) || (xPos > bpx && bvx < 0) {
                    continue
                }
                if (minValue..<maxValue).contains(xPos) && (minValue..<maxValue).contains(yPos) {
                    total += 1
                }
            }
        }
        
        return total
        /*
         for A, B in it.combinations(InputList, 2):
             APX, APY, APZ, AVX, AVY, AVZ = A
             BPX, BPY, BPZ, BVX, BVY, BVZ = B
             MA = (AVY/AVX)
             MB = (BVY/BVX)
             CA = APY - (MA*APX)
             CB = BPY - (MB*BPX)
             if MA == MB:
                 continue
             XPos = (CB-CA)/(MA-MB)
             YPos = MA*XPos + CA
             if (XPos < APX and AVX > 0) or (XPos > APX and AVX < 0) or (XPos < BPX and BVX > 0) or (XPos > BPX and BVX < 0):
                 continue
             if Min <= XPos <= Max and Min <= YPos <= Max:
                 Part1Answer += 1
         */
    }
    
    // https://www.youtube.com/watch?v=guOyA7Ijqgk
    public func part1b(_ input: [String], minValue: Double, maxValue: Double) -> Int {
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
      
    public func part2(_ input: [String]) -> Int {
        let hailstones = parse(input)
        var potentialXOptions = Set<Int>()
        var potentialYOptions = Set<Int>()
        var potentialZOptions = Set<Int>()
        for (i, hs1) in hailstones.enumerated() {
            for hs2 in hailstones[(i+1)...] {
                let (apx, apy, apz, avx, avy, avz) = (Int(hs1.x), Int(hs1.y), Int(hs1.z), Int(hs1.vx), Int(hs1.vy), Int(hs1.vz))
                let (bpx, bpy, bpz, bvx, bvy, bvz) = (Int(hs2.x), Int(hs2.y), Int(hs2.z), Int(hs2.vx), Int(hs2.vy), Int(hs2.vz))
                
                if avx == bvx && abs(avx) > 100 {
                    var newOptions = Set<Int>()
                    let diff = bpx - apx
                    for v in (-1000...1000) {
                        if v == avx {
                            continue
                        }
                        if diff % (v - avx) == 0 {
                            newOptions.insert(v)
                        }
                    }
                    if potentialXOptions.isEmpty {
                        potentialXOptions = newOptions
                    } else {
                        potentialXOptions = potentialXOptions.intersection(newOptions)
                    }
                }
                if avy == bvy && abs(avy) > 100 {
                    var newOptions = Set<Int>()
                    let diff = bpy - apy
                    for v in (-1000...1000) {
                        if v == avy {
                            continue
                        }
                        if diff % (v - avy) == 0 {
                            newOptions.insert(v)
                        }
                    }
                    if potentialYOptions.isEmpty {
                        potentialYOptions = newOptions
                    } else {
                        potentialYOptions = potentialYOptions.intersection(newOptions)
                    }
                }
                if avz == bvz && abs(avz) > 100 {
                    var newOptions = Set<Int>()
                    let diff = bpz - apz
                    for v in (-1000...1000) {
                        if v == avz {
                            continue
                        }
                        if diff % (v - avz) == 0 {
                            newOptions.insert(v)
                        }
                    }
                    if potentialZOptions.isEmpty {
                        potentialZOptions = newOptions
                    } else {
                        potentialZOptions = potentialZOptions.intersection(newOptions)
                    }
                }
            }
        }
        
        print(potentialXOptions, potentialYOptions, potentialZOptions)
        let rvx = potentialXOptions.popFirst()!
        let rvy = potentialYOptions.popFirst()!
        let rvz = potentialZOptions.popFirst()!
        
        let hs1 = hailstones[0]
        let hs2 = hailstones[1]
        let m1 = (hs1.vy - Double(rvy)) / (hs1.vx - Double(rvx))
        let m2 = (hs2.vy - Double(rvy)) / (hs2.vx - Double(rvx))

        let c1 = hs1.y - (m1 * hs1.x)
        let c2 = hs2.y - (m2 * hs2.x)
        
        let xPos = Int((c2 - c1) / (m1 - m2))
        let yPos = Int(m1 * Double(xPos) + c1)
        let time = (Double(xPos) - hs1.x) / (hs1.vx - Double(rvx))
        let zPos = Int(hs1.z + (hs1.vz - Double(rvz)) * Double(time))

        print(xPos, yPos, zPos)
        
        return xPos + yPos + zPos
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
