import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    /// These regex would have worked if I'd put the {1,3} in
    /// mul\(\d{1,3},\d{1,3}\)
    /// mul\(\d{1,3},\d{1,3}\)|do\(\)|don\'t\(\)
    
    public func part1(_ input: [String]) throws -> Int {
        parse(input, isConditional: false).reduce(0) { $0 + $1.value1 * $1.value2 }
    }
    
    public func part2(_ input: [String]) -> Int {
        parse(input, isConditional: true).reduce(0) { $0 + $1.value1 * $1.value2 }
    }
}

extension Day3 {
    struct Instruction {
        let value1: Int
        let value2: Int
    }
    
    public func lookup(_ input: String, i: Int, value: String, inputLength: Int) -> Bool {
        guard i+value.count < inputLength else { return false }
        return input[i...i+value.count-1] == value
    }
    
    public func extractNumber(_ input: String, i: inout Int, end: String, inputLength: Int) -> Int? {
        var valString = ""
        
        while i < inputLength && Character(String(input[i])).isNumber {
            valString += String(input[i])
            i += 1
        }
        guard input[i] == end else {
            i += 1
            return nil
        }
        i += 1
        
        if let value = Int(valString) {
            return value
        } else {
            return nil
        }
    }
    
    func parse(_ lines: [String], isConditional: Bool) -> [Instruction] {
        var results = [Instruction]()
        var enabled = true
        
        for input in lines {
            var i = 0
            let inputLength = input.count
            
            outerloop: while i < inputLength {
                if lookup(input, i: i, value: "mul(", inputLength: inputLength) {
                    i += 4
                    var val1 = 0
                    var val2 = 0
                    
                    if let value = extractNumber(input, i: &i, end: ",", inputLength: inputLength) {
                        val1 = value
                    } else {
                        continue outerloop
                    }
                    
                    if let value = extractNumber(input, i: &i, end: ")", inputLength: inputLength) {
                        val2 = value
                    } else {
                        continue outerloop
                    }
                    
                    if enabled {
                        results.append(Instruction(value1: val1, value2: val2))
                    }
                    continue outerloop
                } else if isConditional, lookup(input, i: i, value: "do()", inputLength: inputLength) {
                    enabled = true
                    i += 4
                    continue outerloop
                } else if isConditional, lookup(input, i: i, value: "don't()", inputLength: inputLength) {
                    enabled = false
                    i += 7
                    continue outerloop
                }
                
                i += 1
            }
        }
        
        return results
    }
}
