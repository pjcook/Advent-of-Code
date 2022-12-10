//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let clock = ClockCircuit()
        let instructions = parse(input)
        return clock.run_part1(program: instructions, cycleIndexes: [20, 60, 100, 140, 180, 220])
    }
    
    public func part2(_ input: [String]) {
        let clock = ClockCircuit()
        let instructions = parse(input)
        clock.run_part2(program: instructions)
    }
}

extension Day10 {
    public func parse(_ input: [String]) -> [Instruction] {
        var instructions = [Instruction]()
        
        for line in input {
            let components = line.components(separatedBy: " ")
            if components.count == 2 {
                instructions.append(.addx(Int(components[1])!))
            } else {
                instructions.append(.noop)
            }
        }
        
        return instructions
    }
}

extension Day10 {
    public enum Instruction {
        case addx(Int)
        case noop
        
        var cycles: Int {
            switch self {
            case .addx: return 2
            case .noop: return 1
            }
        }
    }
    public struct CRT {
        let rows = 40
        let cols = 6
    }
    
    public struct ClockCircuit {
        public init() {}
        
        public func run_part1(program: [Instruction], cycleIndexes: [Int]) -> Int {
            var total = 0
            var cycleIndexes = cycleIndexes
            var nextCycle = cycleIndexes.removeFirst()
            var x = 1
            var timestamp = 1
            var instructionPointer = 0
            
            while true {
                let instruction = program[instructionPointer]
                timestamp += instruction.cycles
                if timestamp > nextCycle {
                    total += nextCycle * x
                    if !cycleIndexes.isEmpty {
                        nextCycle = cycleIndexes.removeFirst()
                    } else {
                        return total
                    }
                }
                
                switch instruction {
                case .noop:
                    break
                    
                case .addx(let value):
                    x += value
                }
                instructionPointer += 1
                if instructionPointer >= program.count {
                    instructionPointer = 0
                }
            }
        }
        
        public func run_part2(program: [Instruction]) {
            var grid = Grid<Character>(columns: 40, items: Array(repeating: ".", count: 240))
            
            var x = 1
            var timestamp = 0
            var instructionPointer = 0
            
            func lightPixel() {
                let crtPointer = ((timestamp / 40) * 40) + x
                if (crtPointer-1...crtPointer+1).contains(timestamp) {
                    grid.items[timestamp] = "#"
                } else {
                    grid.items[timestamp] = "."
                }
            }
            
            while timestamp < 240 {
                let instruction = program[instructionPointer]
                
                lightPixel()
                
                switch instruction {
                case .noop:
                    timestamp += 1
                    
                case .addx(let value):
                    timestamp += 1
                    lightPixel()
                    timestamp += 1
                    x += value
                }
                
                instructionPointer += 1
                if instructionPointer >= program.count {
                    instructionPointer = 0
                }
            }
            
            print()
            grid.draw()
            print()
        }
    }
}
