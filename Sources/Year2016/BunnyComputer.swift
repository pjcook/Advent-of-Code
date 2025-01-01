//
//  File.swift
//  AdventOfCode
//
//  Created by PJ on 01/01/2025.
//

import Foundation
import StandardLibraries

public final class BunnyComputer {
    public var a: Int
    public var b: Int
    public var c: Int
    public var d: Int
    private var instructionPointer: Int = 0
    private var program: [BunnyComputerInstruction] = []
    
    public init(a: Int = 0, b: Int = 0, c: Int = 0, d: Int = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    
    public func execute(program input: [BunnyComputerInstruction]) {
        program = input

        while instructionPointer < program.count {
            let instruction = program[instructionPointer]
            process(instruction: instruction)
        }
    }
    
    public func process(instruction: BunnyComputerInstruction) {
        switch instruction {
        case .copy(let value, let register):
            // cpy x y copies x (either an integer or the value of a register) into register y.
            switch (value, register) {
                
            case (.value, .value): break
                
            case (.register, .value): break
                
            case let (.value(a), .register(b)):
                switch b {
                case .a:
                    self.a = a
                case .b:
                    self.b = a
                case .c:
                    self.c = a
                case .d:
                    self.d = a
                }
                
            case let (.register(a), .register(b)):
                var value = 0
                switch a {
                case .a:
                    value = self.a
                case .b:
                    value = self.b
                case .c:
                    value = self.c
                case .d:
                    value = self.d
                }
                
                switch b {
                case .a:
                    self.a = value
                case .b:
                    self.b = value
                case .c:
                    self.c = value
                case .d:
                    self.d = value
                }
            }
            
        case let .increase(register):
            // inc x increases the value of register x by one.
            switch register {
            case let .register(a):
                switch a {
                case .a:
                    self.a += 1
                case .b:
                    self.b += 1
                case .c:
                    self.c += 1
                case .d:
                    self.d += 1
                }
                
            case .value:
                break
            }
            
        case let .decrease(register):
            // dec x decreases the value of register x by one.
            switch register {
            case let .register(a):
                switch a {
                case .a:
                    self.a -= 1
                case .b:
                    self.b -= 1
                case .c:
                    self.c -= 1
                case .d:
                    self.d -= 1
                }
                
            case .value:
                break
            }
            
        case let .jump(a, b):
            // jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
            var value1 = 0
            var value2 = 0

            switch a {
            case let .register(register):
                switch register {
                case .a:
                    value1 = self.a
                case .b:
                    value1 = self.b
                case .c:
                    value1 = self.c
                case .d:
                    value1 = self.d
                }
                
            case let .value(v):
                value1 = v
            }
            
            switch b {
            case let .register(register):
                switch register {
                case .a:
                    value2 = self.a
                case .b:
                    value2 = self.b
                case .c:
                    value2 = self.c
                case .d:
                    value2 = self.d
                }
                
            case let .value(v):
                value2 = v
            }
            
            if value1 != 0 {
                self.instructionPointer += value2
                return
            }
            
        case let .toggle(v):
            var value = instructionPointer
            switch v {
            case let .register(register):
                switch register {
                case .a:
                    value += self.a
                case .b:
                    value += self.b
                case .c:
                    value += self.c
                case .d:
                    value += self.d
                }
                
            case .value:
                break
            }
            
            if (0..<program.count).contains(value) {
                let instruction = program[value]
                switch instruction {
                case let .increase(v):
                    program[value] = .decrease(v)
                    
                case let .decrease(v):
                    program[value] = .increase(v)
                    
                case let .toggle(v):
                    program[value] = .increase(v)
                    
                case let .copy(v1, v2):
                    program[value] = .jump(v1, v2)
                    
                case let .jump(v1, v2):
                    program[value] = .copy(v1, v2)
                }
            }
        }
        
        instructionPointer += 1
    }
}

public enum BunnyComputerRegister: String {
    case a, b, c, d
}

public enum BunnyComputerInstructionValue {
    case value(Int)
    case register(BunnyComputerRegister)
    
    public init?(rawValue: String) {
        if let value = Int(rawValue) {
            self = .value(value)
        } else if let register = BunnyComputerRegister(rawValue: rawValue) {
            self = .register(register)
        } else {
            return nil
        }
    }
}

public enum BunnyComputerInstruction {
    case copy(BunnyComputerInstructionValue, BunnyComputerInstructionValue)
    case increase(BunnyComputerInstructionValue)
    case decrease(BunnyComputerInstructionValue)
    case jump(BunnyComputerInstructionValue, BunnyComputerInstructionValue)
    case toggle(BunnyComputerInstructionValue)
    
    public init(_ value: String) {
        self.init(rawValue: value)!
    }
    
    public init?(rawValue: String) {
        let parts = rawValue.split(separator: " ")
        
        switch parts[0] {
        case "cpy": self = .copy(BunnyComputerInstructionValue(rawValue: String(parts[1]))!, BunnyComputerInstructionValue(rawValue: String(parts[2]))!)
        case "inc": self = .increase(BunnyComputerInstructionValue(rawValue: String(parts[1]))!)
        case "dec": self = .decrease(BunnyComputerInstructionValue(rawValue: String(parts[1]))!)
        case "jnz": self = .jump(BunnyComputerInstructionValue(rawValue: String(parts[1]))!, BunnyComputerInstructionValue(rawValue: String(parts[2]))!)
        case "tgl": self = .toggle(BunnyComputerInstructionValue(rawValue: String(parts[1]))!)
        default: return nil
        }
    }
}
