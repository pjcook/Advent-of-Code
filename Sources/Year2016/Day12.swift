//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let computer = BunnyComputer()
        let program = parse(input)
        computer.execute(program: program)
        return computer.a
    }
    
    public func part2(_ input: [String]) -> Int {
        let computer = BunnyComputer(a: 0, b: 0, c: 1, d: 0)
        let program = parse(input)
        computer.execute(program: program)
        return computer.a
    }
    
    public final class BunnyComputer {
        public var a: Int
        public var b: Int
        public var c: Int
        public var d: Int
        public var instructionPointer: Int = 0
        
        public init(a: Int = 0, b: Int = 0, c: Int = 0, d: Int = 0) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
        }
        
        public func execute(program: [BunnyComputerInstruction]) {
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
                    
                case let (.value(a), .value(b)):
                    fatalError("oops")
                case let (.register(a), .value(b)):
                    fatalError("oops")
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
                    fatalError("oops")
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
                    fatalError("oops")
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
            default: return nil
            }
        }
    }
}

extension Day12 {
    func parse(_ input: [String]) -> [BunnyComputerInstruction] {
        input.map(BunnyComputerInstruction.init)
    }
}
