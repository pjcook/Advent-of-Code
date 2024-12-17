import Foundation
import StandardLibraries

public struct Day17 {
    public init() {}
    
    public func part1(_ computer: Computer) -> String {
        computer.run().map(String.init).joined(separator: ",")
    }
    
    public func part2(_ computer: Computer) -> Int {
        var i = 0 // 13921800000
        computer.a = i
        computer.b = 0
        computer.c = 0
        computer.pointer = 0
        var best = 0
        var fudge = 0
        
        while true {
            var ast = i
            if fudge > 0 {
                ast = i * pow(8, fudge.length) + fudge
            }

            computer.a = ast
            computer.b = 0
            computer.c = 0
            computer.pointer = 0
            let out = computer.run(isPart2: true)
            if out == computer.program {
                return ast
            }
            
            var x = 0
            for (a, b) in zip(out, computer.program) {
                if a == b {
                    x += 1
                } else {
                    break
                }
            }
            if x > 7, x < computer.program.count - 3, x > best {
                fudge = ast
                print(i, fudge, out, ast)
                i = -1
                best = x
            }
            
            if i % 100000 == 0 {
                print(ast, out, String(Int(out.map(String.init).joined())!, radix: 8, uppercase: false), best, computer.program.count, fudge)
            }
            i += 1
        }
    }
}

extension Day17 {
    public final class Computer {
        public var a: Int
        public var b: Int
        public var c: Int
        
        public let program: [Int]
        public var pointer = 0
        
        public init(a: Int, b: Int, c: Int, program: [Int]) {
            self.program = program
            self.a = a
            self.b = b
            self.c = c
        }
        
        public func run(isPart2: Bool = false) -> [Int] {
            var output = [Int]()
            
            func value(for operand: Operand) -> Int {
                switch operand {
                case 0, 1, 2, 3: return operand
                case 4: return a
                case 5: return b
                case 6: return c
                default: return operand // fatalError("Unknown operand \(operand)")
                }
            }
            
            while pointer < program.count {
                let instruction = Instruction(Opcode(rawValue: program[pointer])!, program[pointer + 1])
                
                switch instruction.0 {
                case .adv:
                    /*
                     The adv instruction (opcode 0) performs division. The numerator is the value in the A register. The denominator is found by raising 2 to the power of the instruction's combo operand. (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.) The result of the division operation is truncated to an integer and then written to the A register.
                     */
                    a = a / pow(2, value(for: instruction.1))
                    
                case .bxl:
                    /*
                     The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand, then stores the result in register B.
                     */
                    b = b ^ value(for: instruction.1)
                    
                case .bst:
                    /*
                     The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby keeping only its lowest 3 bits), then writes that value to the B register.
                     */
                    b = value(for: instruction.1) % 8
                    
                case .jnz:
                    /*
                     The jnz instruction (opcode 3) does nothing if the A register is 0. However, if the A register is not zero, it jumps by setting the instruction pointer to the value of its literal operand; if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
                     */
                    if a != 0 {
                        pointer = value(for: instruction.1)
                        continue
                    }
                    
                case .bxc:
                    /*
                     The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then stores the result in register B. (For legacy reasons, this instruction reads an operand but ignores it.)
                     */
                    
                    b = b ^ c
                    
                case .out:
                    /*
                     The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value. (If a program outputs multiple values, they are separated by commas.)
                     */
                    let val = value(for: instruction.1) % 8
                    output.append(val)
                    
                    // exit early
                    if isPart2, Array(program.prefix(output.count)) != output {
                        return output
                    }
                    
                case .bdv:
                    /*
                     The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is stored in the B register. (The numerator is still read from the A register.)
                     */
                    b = a / pow(2, value(for: instruction.1))
                    
                case .cdv:
                    /*
                     The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is stored in the C register. (The numerator is still read from the A register.)
                     */
                    c = a / pow(2, value(for: instruction.1))                    
                }
                
                pointer += 2
            }
            
            return output
        }
    }
    
    enum Opcode: Int {
        case adv = 0
        case bxl = 1
        case bst = 2
        case jnz = 3
        case bxc = 4
        case out = 5
        case bdv = 6
        case cdv = 7
    }
    
    typealias Operand = Int
    typealias Instruction = (Opcode, Operand)
}
/*
 [OPERAND]
 Combo operands 0 through 3 represent literal values 0 through 3.
 Combo operand 4 represents the value of register A.
 Combo operand 5 represents the value of register B.
 Combo operand 6 represents the value of register C.
 Combo operand 7 is reserved and will not appear in valid programs.
 
 [OPCODE]
 The adv instruction (opcode 0) performs division. The numerator is the value in the A register. The denominator is found by raising 2 to the power of the instruction's combo operand. (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.) The result of the division operation is truncated to an integer and then written to the A register.

 The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand, then stores the result in register B.

 The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby keeping only its lowest 3 bits), then writes that value to the B register.

 The jnz instruction (opcode 3) does nothing if the A register is 0. However, if the A register is not zero, it jumps by setting the instruction pointer to the value of its literal operand; if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.

 The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then stores the result in register B. (For legacy reasons, this instruction reads an operand but ignores it.)

 The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value. (If a program outputs multiple values, they are separated by commas.)

 The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is stored in the B register. (The numerator is still read from the A register.)

 The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is stored in the C register. (The numerator is still read from the A register.)
 */
