import Foundation

public struct Day8 {
    /*
     Instructions: acc, jmp, nop
     acc increases or decreases a single global value called the accumulator by the value given in the argument. For example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction, the instruction immediately below it is executed next.
     jmp jumps to a new instruction relative to itself. The next instruction to execute is found using the argument as an offset from the jmp instruction; for example, jmp +2 would skip the next instruction, jmp +1 would continue to the instruction immediately below it, and jmp -20 would cause the instruction 20 lines above to be executed next.
     nop stands for No OPeration - it does nothing. The instruction immediately below it is executed next.
     */
        
    public func part1(_ input: [String]) -> Int {
        let instructions = input.compactMap(Instruction.parse)
        return validate(instructions).1
    }
    
    public func part2(_ input: [String]) -> Int {
        let instructions = input.compactMap(Instruction.parse)
        let indexes = validate(instructions).2
        for index in indexes {
            let instruction = instructions[index]
            switch instruction {
            case .acc: break
            case .jmp, .nop:
                var edited = instructions
                edited[index] = instruction.flipped
                let result = validate(edited)
                if result.0 {
                    return result.1
                }
            }
        }
        return -1
    }
    
    public func validate(_ instructions: [Instruction]) -> (Bool, Int, Set<Int>) {
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()

        while !visited.contains(index) && index < instructions.count {
            visited.insert(index)
            instructions[index].process(index: &index, accumulator: &accumulator)
        }
        
        return (index >= instructions.count, accumulator, visited)
    }
}

extension Instruction {
    func process(index: inout Int, accumulator: inout Int) {
        switch self {
        case .acc(let value):
            accumulator += value
            index += 1
            
        case .jmp(let value):
            index += value
            
        case .nop:
            index += 1
        }
    }
}

extension Day8 {
    public func tokenize(_ value: Substring) -> Int {
        switch value {
        case "acc": return 0
        case "jmp": return 1
        case "nop": return 2
        default: return Int(value)!
        }
    }
}

extension Day8 {
    public func part1_v2(_ input: [String]) -> Int {
        let instructions = input.map { $0.split(separator: " ") }
        return validate(instructions).1
    }
    
    public func part2_v2(_ input: [String]) -> Int {
        let instructions = input.map { $0.split(separator: " ") }
        let result = validate(instructions)
        for index in result.2 {
            var edited = instructions
            switch instructions[index][0] {
            case "jmp":
                edited[index][0] = "nop"
                let result = validate(edited)
                if result.0 {
                    return result.1
                }

            case "nop":
                edited[index][0] = "jmp"
                let result = validate(edited)
                if result.0 {
                    return result.1
                }

            default:
                break
            }
            
        }
        return -1
    }
    
    public func validate(_ instructions: [[String.SubSequence]]) -> (Bool, Int, Set<Int>) {
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()

        while !visited.contains(index) && index < instructions.count {
            visited.insert(index)
            switch instructions[index][0] {
            case "acc":
                accumulator += Int(instructions[index][1])!
                index += 1
                
            case "jmp":
                index += Int(instructions[index][1])!
                
            case "nop":
                index += 1
                
            default:
                break
            }
        }
        
        return (index >= instructions.count, accumulator, visited)
    }
}

extension Day8 {
    public func part1_v3(_ input: [String]) -> Int {
        let instructions = input
            .map {
                $0.split(separator: " ")
                    .map(tokenize)
            }
        return validate(instructions).1
    }
    
    public func part2_v3(_ input: [String]) -> Int {
        let instructions = input
            .map {
                $0.split(separator: " ")
                    .map(tokenize)
            }
        let result = validate(instructions)
        for index in result.2 {
            var edited = instructions
            switch instructions[index][0] {
            case 1:
                edited[index][0] = 2
                let result = validate(edited)
                if result.0 {
                    return result.1
                }

            case 2:
                edited[index][0] = 1
                let result = validate(edited)
                if result.0 {
                    return result.1
                }

            default:
                break
            }
            
        }
        return -1
    }
    
    public func validate(_ instructions: [[Int]]) -> (Bool, Int, Set<Int>) {
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()

        while !visited.contains(index) && index < instructions.count {
            visited.insert(index)
            switch instructions[index][0] {
            case 0:
                accumulator += instructions[index][1]
                index += 1
                
            case 1:
                index += instructions[index][1]
                
            case 2:
                index += 1
                
            default:
                break
            }
        }
        
        return (index >= instructions.count, accumulator, visited)
    }
}
