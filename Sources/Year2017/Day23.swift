//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let instructions = parse(input)
        var pointer = 0
        var registers: [Register: Value] = [:]
        var count = 0
        
        while pointer < instructions.count {
            let instruction = instructions[pointer]
            var jumped = false
            switch instruction {
            case let .decrement(register, value):
                registers[register] = registers[register, default: 0] - value.value(with: registers)
                
            case let .set(register, value):
                registers[register] = value.value(with: registers)
                
            case let .multiply(register, value):
                registers[register] = registers[register, default: 0] * value.value(with: registers)
                count += 1
                
            case let .jump(value1, value2):
                if value1.value(with: registers) != 0 {
                    pointer += value2
                    jumped = true
                }
            }
            
            if !jumped {
                pointer += 1
            }
        }
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        // The second part need to optimize the assembly code by hand (see the
        // analysis/ directory for steps). The last step show that the register `h`
        // value is set to the count of composite (i.e. non-prime) numbers in the
        // firsts 1001 numbers starting from 93 * 100 + 100000 by steps of 17.

        // Returns true if n is prime, false otherwise.
        func is_prime(_ n: Int) -> Bool {
          // Naive algorithm checking each possible divisor from 2 to sqrt(n).
          let sqrt = Int(Double(n).squareRoot())
          return n > 1 && !(2...sqrt).contains { n % $0 == 0 }
        }

        let step = 17
        // When a != 0 we have this preamble to setup b (the starting number) and c
        // (the limit).
        let b = 93 * 100 + 100000
        let c = b + step * 1001

        // Now compute h using the is_prime() function.
        let h = stride(from: b, to: c, by: step).reduce(0) { acc, i in
          acc + (is_prime(i) ? 0 : 1)
        }

        return h
    }
    
    typealias Register = Character
    typealias Value = Int
    
    enum OpCode {
        case value(Value)
        case register(Register)
        
        init(_ input: String) {
            if let value = Int(input) {
                self = .value(value)
            } else {
                self = .register(Register(input))
            }
        }
        
        func value(with registers: [Register: Int]) -> Int {
            switch self {
            case let .value(value): return value
            case let .register(register): return registers[register, default: 0]
            }
        }
    }
    /*
     set X Y sets register X to the value of Y.
     sub X Y decreases register X by the value of Y.
     mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
     jnz X Y jumps with an offset of the value of Y, but only if the value of X is not zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
     */
    enum Op {
        case set(Register, OpCode)
        case decrement(Register, OpCode)
        case multiply(Register, OpCode)
        case jump(OpCode, Value)
        
        init(_ input: String) {
            let parts = input.split(separator: " ").map(String.init)
            switch parts[0] {
            case "set": self = .set(Register(parts[1]), OpCode(parts[2]))
                
            case "sub": self = .decrement(Register(parts[1]), OpCode(parts[2]))
                
            case "mul": self = .multiply(Register(parts[1]), OpCode(parts[2]))
                
            case "jnz": self = .jump(OpCode(parts[1]), Value(parts[2])!)
                
            default: fatalError("Unknown op \(parts[0])")
            }
        }
    }
}

extension Day23 {
    func parse(_ input: [String]) -> [Op] {
        input.map(Op.init)
    }
}
