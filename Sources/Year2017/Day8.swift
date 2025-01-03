//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day8 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var registers = [String: Int]()
        
        for instruction in parse(input) {
            guard instruction.command.isValid(a: registers[instruction.register, default: 0], b: instruction.checkValue) else { continue }
            registers[instruction.id] = instruction.op.execute(a: registers[instruction.id, default: 0], b: instruction.value)
        }
        
        return registers.values.max()!
    }
    
    public func part2(_ input: [String]) -> Int {
        var registers = [String: Int]()
        var maximum = 0
        
        for instruction in parse(input) {
            guard instruction.command.isValid(a: registers[instruction.register, default: 0], b: instruction.checkValue) else { continue }
            let value = instruction.op.execute(a: registers[instruction.id, default: 0], b: instruction.value)
            registers[instruction.id] = value
            maximum = max(maximum, value)
        }
        
        return maximum
    }
    
    enum OpCode: String {
        case inc
        case dec
        
        func execute(a: Int, b: Int) -> Int {
            switch self {
            case .dec: return a - b
            case .inc: return a + b
            }
        }
    }
    
    enum Command: String {
        case greaterThan = ">"
        case lessThan = "<"
        case equal = "=="
        case greaterThanOrEqual = ">="
        case lessThanOrEqual = "<="
        case notEqual = "!="
        
        func isValid(a: Int, b: Int) -> Bool {
            switch self {
            case .greaterThan: return a > b
            case .lessThan: return a < b
            case .equal: return a == b
            case .greaterThanOrEqual: return a >= b
            case .lessThanOrEqual: return a <= b
            case .notEqual: return a != b
            }
        }
    }
    
    struct Instruction {
        let id: String
        let op: OpCode
        let value: Int
        let register: String
        let command: Command
        let checkValue: Int
        
        init(_ input: String) {
            let parts = input.split(separator: " ").map(String.init)
            id = parts[0]
            op = OpCode(rawValue: parts[1])!
            value = Int(parts[2])!
            register = parts[4]
            command = Command(rawValue: parts[5])!
            checkValue = Int(parts[6])!
        }
    }
}

extension Day8 {
    func parse(_ input: [String]) -> [Instruction] {
        return input.map(Instruction.init)
    }
}
