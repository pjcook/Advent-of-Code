//
//  Day19.swift
//  Year2019
//
//  Created by PJ COOK on 18/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day19 {
    public init() {}
    private let computer = Computer(forceWriteMode: false)
    private var program = [Int]()
    private var output = [Int]()
    private var finished = false
    private var isPart2 = false
    private var inputInstructions: [Int] = []
    private var inputInstructionPointer = 0

    public func part1(_ input: [Int]) -> Int {
        program = input
        output = []
        finished = false
        isPart2 = false
        inputInstructionPointer = 0
        inputInstructions = []
        computer.reset()
        computer.delegate = self
        computer.loadProgram(input)
        

        for y in 0..<50 {
            var foundStart = false
            for x in 0..<50 {
                inputInstructions.append(x)
                inputInstructions.append(y)
                while !finished {
                    computer.tick()
                }
                finished = false
                if foundStart, output.last == 0 {
                    break
                } else if output.last == 1 {
                    foundStart = true
                }
            }
        }

        
        return output.reduce(0, +)
    }
    
    public func part2(_ input: [Int]) -> Int {
        program = input
        finished = false
        isPart2 = false
        computer.reset()
        computer.delegate = self
        computer.loadProgram(input)
        var startIndex = 0
        var longest = 0
        var skip = 0
        
        outerloop: for y in 0..<10000 {
            output = []
            var foundStart = false
            startIndex = 0
            while skip > 0 {
                skip -= 1
                continue outerloop
            }
            for x in 0..<10000 {
                inputInstructionPointer = 0
                inputInstructions = []
                inputInstructions.append(x)
                inputInstructions.append(y)
                while !finished {
                    computer.tick()
                }
                finished = false
                if foundStart, output.last == 0 {
                    longest = max(longest, x - startIndex)
                    skip = 199 - (x - startIndex)
                    if skip < 50 {
                        skip = 2
                    }
                    if x - startIndex >= 100 {
                        let dx = x - 100
                        inputInstructionPointer = 0
                        inputInstructions = []
                        inputInstructions.append(dx)
                        inputInstructions.append(y+99)
                        while !finished {
                            computer.tick()
                        }
                        
                        if output.last == 1 {
                            return (x - 100) * 10000 + y
                        }
                        finished = false
                    }
                    break
                } else if startIndex == 0, output.last == 1 {
                    foundStart = true
                    startIndex = x
                }
            }
        }

        return -1
    }
}

extension Day19: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        let value = inputInstructions[inputInstructionPointer]
        inputInstructionPointer += 1
        return value
    }
    
    public func computerFinished(id: Int) {
        finished = inputInstructionPointer >= inputInstructions.count
        computer.reset()
        computer.loadProgram(program)
    }
    
    public func processOutput(id: Int, value: Int) {
        output.append(value)
    }
}
