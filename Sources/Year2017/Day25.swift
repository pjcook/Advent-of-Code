//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day25 {
    public init() {}
    
    public func part1(_ states: [String: State], steps: Int) -> Int {
        var cursor = 0
        var tape: [Int: Int] = [0:0]
        var state = states["A"]!
        
        for _ in 0..<steps {
            let instruction = state.instructions[tape[cursor, default: 0]]
            tape[cursor] = instruction.write
            cursor += instruction.move
            state = states[instruction.nextState]!
        }
        
        return tape.values.reduce(0, +)
    }
    
    public struct Instruction {
        public let write: Int
        public let move: Int
        public let nextState: String
        
        public init(write: Int, move: Int, nextState: String) {
            self.write = write
            self.move = move
            self.nextState = nextState
        }
    }
    
    public struct State {
        public let id: String
        public let instructions: [Instruction]
        
        public init(id: String, instructions: [Instruction]) {
            self.id = id
            self.instructions = instructions
        }
    }
}
