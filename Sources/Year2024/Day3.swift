import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
//    public let regex = try! RegularExpression(pattern: "(mul\\(\\d,\\d\\))")
    
    public func part1(_ input: [String]) throws -> Int {
        var result = 0
        
        for line in input {
            let instructions = parse(line)
            for instruction in instructions {
                switch instruction.prefix {
                case "mul": result += instruction.value1 * instruction.value2
                default: break
                }
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        var result = 0
        let instructions = parse2(input)

        for instruction in instructions {
            switch instruction.prefix {
            case "mul": result += instruction.value1 * instruction.value2
            default: break
            }
        }

        return result
    }
}

extension Day3 {
    struct Instruction {
        let prefix: String
        let value1: Int
        let value2: Int
    }
    
    func parse(_ input: String) -> [Instruction] {
        var results = [Instruction]()
        var valString = ""
        var val1 = 0
        var val2 = 0
        var i = 0
        let inputLength = input.count
        
        outerloop: while i < inputLength {
            if input[i] == "m", i+7 < inputLength, input[i+1] == "u", input[i+2] == "l", input[i+3] == "(" {
                i += 4
                valString = ""
                val1 = 0
                val2 = 0
                
                while i < inputLength && Character(String(input[i])).isNumber {
                    valString += String(input[i])
                    i += 1
                }
                guard input[i] == "," else {
                    i += 1
                    continue outerloop
                }
                i += 1
                
                if let value = Int(valString) {
                    val1 = value
                } else {
                    continue outerloop
                }
                
                valString = ""
                while i < inputLength && Character(String(input[i])).isNumber {
                    valString += String(input[i])
                    i += 1
                }
                guard input[i] == ")" else {
                    i += 1
                    continue outerloop
                }
                i += 1
                
                if let value = Int(valString) {
                    val2 = value
                } else {
                    continue outerloop
                }
                
                results.append(Instruction(prefix: "mul", value1: val1, value2: val2))
                continue outerloop
            }
            
            i += 1
        }
        
        return results
    }
    
    func parse2(_ lines: [String]) -> [Instruction] {
        var results = [Instruction]()
        var valString = ""
        var val1 = 0
        var val2 = 0
        var enabled = true
        
        for input in lines {
            var i = 0
            var inputLength = input.count
            
            outerloop: while i < inputLength {
                if input[i] == "m", i+7 < inputLength, input[i+1] == "u", input[i+2] == "l", input[i+3] == "(" {
                    i += 4
                    valString = ""
                    val1 = 0
                    val2 = 0
                    
                    while i < inputLength && Character(String(input[i])).isNumber {
                        valString += String(input[i])
                        i += 1
                    }
                    guard input[i] == "," else {
                        i += 1
                        continue outerloop
                    }
                    i += 1
                    
                    if let value = Int(valString) {
                        val1 = value
                    } else {
                        continue outerloop
                    }
                    
                    valString = ""
                    while i < inputLength && Character(String(input[i])).isNumber {
                        valString += String(input[i])
                        i += 1
                    }
                    guard input[i] == ")" else {
                        i += 1
                        continue outerloop
                    }
                    i += 1
                    
                    if let value = Int(valString) {
                        val2 = value
                    } else {
                        continue outerloop
                    }
                    
                    if enabled {
                        results.append(Instruction(prefix: "mul", value1: val1, value2: val2))
                    }
                    continue outerloop
                } else if input[i] == "d", i+3 < inputLength && input[i+1] == "o", input[i+2] == "(", input[i+3] == ")" {
                    enabled = true
                } else if input[i] == "d", i+6 < inputLength && input[i+1] == "o", input[i+2] == "n", input[i+3] == "'", input[i+4] == "t", input[i+5] == "(", input[i+6] == ")" {
                    enabled = false
                }
                
                i += 1
            }
        }
        
        return results
    }
}
