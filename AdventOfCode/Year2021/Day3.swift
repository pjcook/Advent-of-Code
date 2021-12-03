import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public struct Diagnostic {
        public let gammaRate: Int
        public let epsilonRate: Int
    }
    
    public func part1(_ input: [String]) -> Int {
        let diagnostic = calculateGammaAndEpsilon(input)
        return diagnostic.gammaRate * diagnostic.epsilonRate
    }
    
    public func part2(_ input: [String]) -> Int {
        return calculateOxygenGeneratorRating(input) * calculateCO2ScrubberRating(input)
    }
    
    public func calculateOxygenGeneratorRating(_ input: [String]) -> Int {
        var input2 = input
        for i in (0..<input2[0].count) {
            var count = 0
            for line in input2 {
                if line[i] == "1" {
                    count += 1
                }
            }
            let sigOne = count >= input2.count - count
            input2 = input2.filter({ value in
                String(value[i]) == (sigOne ? "1" : "0")
            })
            
            if input2.count == 1 {
                return Int(input2[0], radix: 2)!
            }
        }
        return -1
    }
    
    public func calculateCO2ScrubberRating(_ input: [String]) -> Int {
        var input2 = input
        for i in (0..<input2[0].count) {
            var count = 0
            for line in input2 {
                if line[i] == "1" {
                    count += 1
                }
            }
            let sigOne = count >= input2.count - count
            input2 = input2.filter({ value in
                String(value[i]) == (sigOne ? "0" : "1")
            })
            
            if input2.count == 1 {
                return Int(input2[0], radix: 2)!
            }
        }
        return -1
    }
    
    public func calculateGammaAndEpsilon(_ input: [String]) -> Diagnostic {
        var gamma = ""
        var epsilon = ""
        
        for i in (0..<input[0].count) {
            var count = 0
            for line in input {
                if line[i] == "1" {
                    count += 1
                }
            }
            let gammaSignificant = count > input.count - count
            gamma.append(gammaSignificant ? "1" : "0")
            epsilon.append(gammaSignificant ? "0" : "1")
        }
        return Diagnostic(gammaRate: Int(gamma, radix: 2)!, epsilonRate: Int(epsilon,  radix: 2)!)
    }
}
