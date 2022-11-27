import Foundation
import StandardLibraries

public struct Day3b {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let grid = parse(input)
        
        var gamma = ""
        var epsilon = ""
        
        for i in (0..<grid[0].count) {
            let count = grid.reduce(0) { partialResult, items in
                partialResult + items[i]
            }
            let gammaSignificant = count >= input.count - count
            gamma.append(gammaSignificant ? "1" : "0")
            epsilon.append(gammaSignificant ? "0" : "1")
        }
        
        return gamma.binary! * epsilon.binary!
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        return calculateOxygenGeneratorRating(grid) * calculateCO2ScrubberRating(grid)
    }
    
    public func parse(_ input: [String]) -> [[Int]] {
        input.map { $0.map({ Int(String($0))! }) }
    }
    
    public func calculateOxygenGeneratorRating(_ input: [[Int]]) -> Int {
        var input2 = input
        
        for i in (0..<input2[0].count) {
            let count = input2.reduce(0) { partialResult, items in
                partialResult + items[i]
            }
            let sigOne = count >= input2.count - count
            input2 = input2.filter { $0[i] == (sigOne ? 1 : 0) }
            if input2.count == 1 {
                return Int(input2[0].map(String.init).joined(), radix: 2)!
            }
        }
        
        return -1
    }
    
    public func calculateCO2ScrubberRating(_ input: [[Int]]) -> Int {
        var input2 = input
        
        for i in (0..<input2[0].count) {
            let count = input2.reduce(0) { partialResult, items in
                partialResult + items[i]
            }
            let sigOne = count >= input2.count - count
            input2 = input2.filter { $0[i] == (sigOne ? 0 : 1) }
            if input2.count == 1 {
                return Int(input2[0].map(String.init).joined(), radix: 2)!
            }
        }
        
        return -1
    }
}
