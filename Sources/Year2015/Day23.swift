import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let instructions = input.map(OpCode.init)
        let computer = Computer(instructions: instructions)
        computer.execute()
        return computer.b
    }
    
    public func part2(_ input: [String]) -> Int {
        let instructions = input.map(OpCode.init)
        let computer = Computer(instructions: instructions, a: 1)
        computer.execute()
        return computer.b
    }
    
    final class Computer {
        var instructions: [OpCode]
        var a: Int
        var b: Int
        var pointer = 0
        
        init(instructions: [OpCode], a: Int = 0, b: Int = 0) {
            self.instructions = instructions
            self.a = a
            self.b = b
        }
        
        func execute() {
            while (0..<instructions.count).contains(pointer) {
                let instruction = instructions[pointer]
                process(instruction: instruction)
                pointer += 1
            }
        }
        
        func process(instruction: OpCode) {
            switch instruction {
                
            case let .half(register):
                switch register {
                case .a: a /= 2
                case .b: b /= 2
                }
                
            case let .triple(register):
                switch register {
                case .a: a *= 3
                case .b: b *= 3
                }
                
            case let .increment(register):
                switch register {
                case .a: a += 1
                case .b: b += 1
                }
                
            case let .jump(value):
                pointer += value - 1
                
            case let .jumpIfEven(register, value):
                switch register {
                case .a:
                    if a.isEven {
                        pointer += value - 1
                    }
                case .b:
                    if b.isEven {
                        pointer += value - 1
                    }
                }
                
            case let .jumpIfOne(register, value):
                switch register {
                case .a:
                    if a == 1 {
                        pointer += value - 1
                    }
                case .b:
                    if b == 1 {
                        pointer += value - 1
                    }
                }
            }
        }
    }
    
    enum Register: String {
        case a, b
    }
    typealias Value = Int
    /*
     - hlf r sets register r to half its current value, then continues with the next instruction.
     - tpl r sets register r to triple its current value, then continues with the next instruction.
     - inc r increments register r, adding 1 to it, then continues with the next instruction.
     - jmp offset is a jump; it continues with the instruction offset away relative to itself.
     - jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
     - jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
     */
    enum OpCode {
        case half(Register)
        case triple(Register)
        case increment(Register)
        case jump(Value)
        case jumpIfEven(Register, Value)
        case jumpIfOne(Register, Value)
        
        init(_ input: String) {
            let parts = input.replacingOccurrences(of: ",", with: "").split(separator: " ").map(String.init)
            switch parts[0] {
            case "hlf": self = .half(Register(rawValue: parts[1])!)
            case "tpl": self = .triple(Register(rawValue: parts[1])!)
            case "inc": self = .increment(Register(rawValue: parts[1])!)
            case "jmp": self = .jump(Value(parts[1])!)
            case "jie": self = .jumpIfEven(Register(rawValue: parts[1])!, Value(parts[2])!)
            case "jio": self = .jumpIfOne(Register(rawValue: parts[1])!, Value(parts[2])!)
            default: fatalError("Unknown opcode \(parts[0])")
            }
        }
    }
}
