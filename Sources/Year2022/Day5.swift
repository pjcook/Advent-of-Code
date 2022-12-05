//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public typealias CreateStack = [Character]
public typealias Stacks = [Int: CreateStack]
public typealias Instruction = (Int, Int, Int)
public typealias Instructions = [Instruction]

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [String], crateIndex: Int = 8) throws -> String {
        var (stacks, instructions) = try parse(input, crateIndex: crateIndex)
        var result = ""
        
        for instruction in instructions {
            move(stacks: &stacks, instruction: instruction)
        }
        
        for i in (1...9) {
            if let stack = stacks[i], let char = stack.last {
                result.append(char)
            }
        }
        return result
    }
    
    public func part2(_ input: [String], crateIndex: Int = 8) throws -> String {
        var (stacks, instructions) = try parse(input, crateIndex: crateIndex)
        var result = ""
        
        for instruction in instructions {
            move9001(stacks: &stacks, instruction: instruction)
        }
        
        for i in (1...9) {
            if let stack = stacks[i], let char = stack.last {
                result.append(char)
            }
        }
        return result
    }
}

extension Day5 {
    public func move(stacks: inout Stacks, instruction: Instruction) {
        var fromStack = stacks[instruction.1, default: CreateStack()]
        var toStack = stacks[instruction.2, default: CreateStack()]

        for _ in (0..<instruction.0) {
            if let crate = fromStack.popLast() {
                toStack.append(crate)
            }
        }
        
        stacks[instruction.1] = fromStack
        stacks[instruction.2] = toStack
    }
    
    public func move9001(stacks: inout Stacks, instruction: Instruction) {
        var fromStack = stacks[instruction.1, default: CreateStack()]
        var toStack = stacks[instruction.2, default: CreateStack()]
        var stack = CreateStack()
        
        for _ in (0..<instruction.0) {
            if let crate = fromStack.popLast() {
                stack.insert(crate, at: 0)
            }
        }
        
        toStack.append(contentsOf: stack)
        stacks[instruction.1] = fromStack
        stacks[instruction.2] = toStack
    }
    
    public func parse(_ lines: [String], crateIndex: Int) throws -> (Stacks, Instructions) {
        var stacks = Stacks()
        let stackPositions = [1, 5, 9, 13, 17, 21, 25, 29, 33]
        
        for i in (0..<crateIndex) {
            let line = lines[i]
            for j in (1...9) {
                if line.count > j {
                    let position = stackPositions[j-1]
                    let value = line[position]
                    guard value != " " && !value.isEmpty else { continue }
                    var stack = stacks[j, default: CreateStack()]
                    stack.insert(Character(String(value)), at: 0)
                    stacks[j] = stack
                }
            }
        }
        
        let regex = try RegularExpression(pattern: "[\\w]* ([\\d]+) [\\w]* ([\\d]+) [\\w]* ([\\d]+)")
        var instructions = Instructions()
        
        for i in (crateIndex+2..<lines.count) {
            let line = lines[i]
//            let components = line.components(separatedBy: " ")
//            let instruction = (Int(components[1])!, Int(components[3])!, Int(components[5])!)
            let match = try regex.match(line)
            let instruction = try (match.integer(at: 0), match.integer(at: 1), match.integer(at: 2))
            instructions.append(instruction)
        }
        
        return (stacks, instructions)
    }
}
