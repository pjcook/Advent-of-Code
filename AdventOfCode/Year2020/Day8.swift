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
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()
        
        while !visited.contains(index) {
            visited.insert(index)
            switch instructions[index] {
            case let .acc(value):
                accumulator += value
                index += 1
                
            case let .jmp(value):
                index += value
                
            case .nop:
                index += 1
            }
        }
        return accumulator
    }
    
    public func part2(_ input: [String]) -> Int {
        let instructions = input.compactMap(Instruction.parse)
        for (index, instruction) in instructions.enumerated() {
            var edited = instructions
            switch instruction {
            case .jmp:
                edited[index] = .nop(0)
                let result = validate(edited)
                if result.0 {
                    return result.1
                }

            case let .nop(value):
                edited[index] = .jmp(value)
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
    
    public func validate(_ instructions: [Instruction]) -> (Bool, Int) {
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()

        while !visited.contains(index) && index < instructions.count {
            visited.insert(index)
            switch instructions[index] {
            case let .acc(value):
                accumulator += value
                index += 1
                
            case let .jmp(value):
                index += value
                
            case .nop:
                index += 1
            }
        }
        
        return (index >= instructions.count, accumulator)
    }
}

extension Day8 {
    public enum Instruction {
        case acc(Int)
        case jmp(Int)
        case nop(Int)

        public static func parse(_ input: String) -> Instruction? {
            let parts = input.components(separatedBy: " ")
            switch parts[0] {
            case "acc":
                return Instruction.acc(Int(parts[1])!)
            case "jmp":
                return Instruction.jmp(Int(parts[1])!)
            case "nop":
                return Instruction.nop(Int(parts[1])!)
            default:
                return nil
            }
        }
    }
    
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
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()
        
        while !visited.contains(index) {
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
        return accumulator
    }
    
    public func part2_v2(_ input: [String]) -> Int {
        let instructions = input.map { $0.split(separator: " ") }
        for (index, instruction) in instructions.enumerated() {
            var edited = instructions
            switch instruction[0] {
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
    
    public func validate(_ instructions: [[String.SubSequence]]) -> (Bool, Int) {
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
        
        return (index >= instructions.count, accumulator)
    }
}

extension Day8 {
    public func part1_v3(_ input: [String]) -> Int {
        let instructions = input
            .map {
                $0.split(separator: " ")
                    .map(tokenize)
            }
        var accumulator = 0
        var index = 0
        var visited = Set<Int>()
        
        while !visited.contains(index) {
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
        return accumulator
    }
    
    public func part2_v3(_ input: [String]) -> Int {
        let instructions = input
            .map {
                $0.split(separator: " ")
                    .map(tokenize)
            }
        for (index, instruction) in instructions.enumerated() {
            var edited = instructions
            switch instruction[0] {
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
    
    public func validate(_ instructions: [[Int]]) -> (Bool, Int) {
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
        
        return (index >= instructions.count, accumulator)
    }
}
