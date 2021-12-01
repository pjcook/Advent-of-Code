import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    public let validCharacters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    public let validIncrementCharacters = ["a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    public func part1(_ input: [String]) -> String {
        var input = increment(input)
        while !isValid(input) {
            input = increment(input)
        }
        return input.joined()
    }
    
    public func part2(_ input: [String]) -> String {
        return part1(input)
    }
    
    public func isValid(_ input: [String]) -> Bool {
        return hasStraight(input) && hasNonOverlappingPairs(input)
    }
    
    public func increment(_ input: [String]) -> [String] {
        return increment(input, index: input.count - 1)
    }
    
    public func increment(_ input: [String], index: Int) -> [String] {
        var letter = input[index]
        var input = input
        if letter == validIncrementCharacters.last! {
            letter = validIncrementCharacters.first!
            if index > 0 {
                input = increment(input, index: index - 1)
            }
        } else {
            let i = validIncrementCharacters.firstIndex(of: letter)!
            letter = validIncrementCharacters[i + 1]
        }
        input[index] = letter
        return input
    }
    
    public func hasStraight(_ input: [String]) -> Bool {
        for i in (2..<input.count) {
            let a = input[i-2]
            let b = input[i-1]
            let c = input[i]
            
            if ["y", "z"].contains(a) {
                continue
            }
            
            if let index = validCharacters.firstIndex(of: a), validCharacters[index + 1] == b && validCharacters[index + 2] == c {
                return true
            }
        }
        return false
    }
    
    public func hasNonOverlappingPairs(_ input: [String]) -> Bool {
        var count = 0
        var index = 1
        
        while index < input.count {
            if input[index-1] == input[index] {
                count += 1
                index += 1
            }
            index += 1
        }
            
        return count >= 2
    }
}
