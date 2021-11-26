import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var total = 0
        
        for row in input where !row.isEmpty {
            let components = row.components(separatedBy: "x").map({ Int($0)! })
            let a = components[0] * components[1]
            let b = components[0] * components[2]
            let c = components[1] * components[2]
            let m = min(a, b, c)
            total += 2 * a + 2 * b + 2 * c + m
        }
        
        return total
    }
    
    public func part2(_ input: [String]) -> Int {
        var total = 0
        
        for row in input where !row.isEmpty {
            let comp = row.components(separatedBy: "x").map({ Int($0)! }).sorted()
            let a = comp[0], b = comp[1], c = comp[2]
            total += a + a + b + b + a * b * c
        }
        
        return total
    }
}
