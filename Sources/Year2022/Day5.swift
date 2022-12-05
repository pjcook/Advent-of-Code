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
public typealias Move = ((inout Stacks, Instruction) -> Void)

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [String]) throws -> String {
        try parse(input, move: move)
    }
    
    public func part2(_ input: [String]) throws -> String {
        try parse(input, move: move9001)
    }
}

extension Day5 {
    // Move function for part1
    public func move(_ stacks: inout Stacks, _ instruction: Instruction) {
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
    
    // Move function for part2
    public func move9001(_ stacks: inout Stacks, _ instruction: Instruction) {
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
    
    public func parse(_ lines: [String], move: Move) throws -> String {
        // Find blank line separating top and bottom sections of the file
        let crateIndex = (lines.firstIndex(of: "") ?? 1) - 1
        
        // Parse the top section of the file
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
        
        // Parse the bottom section of the file executing instructions as you go
        let regex = try RegularExpression(pattern: "[\\w]* ([\\d]+) [\\w]* ([\\d]+) [\\w]* ([\\d]+)")
        
        for i in (crateIndex+2..<lines.count) {
            let line = lines[i]
            let match = try regex.match(line)
            let instruction = try (match.integer(at: 0), match.integer(at: 1), match.integer(at: 2))
            move(&stacks, instruction)
        }
        
        // Calculate final result
        var result = ""
        for i in (1...9) {
            if let stack = stacks[i], let char = stack.last {
                result.append(char)
            }
        }
        
        return result
    }
}
