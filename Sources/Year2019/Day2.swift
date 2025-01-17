//
//  Day2.swift
//  Year2019
//
//  Created by PJ COOK on 03/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let computer = Computer(forceWriteMode: true)
        computer.loadProgram(input)
        
        while !computer.isFinished {
            computer.tick()
        }
        
        return computer.registerValue(for: 0) ?? -1
    }
    
    public func part2(_ input: [Int], expectedOutput: Int) -> Int {
        let computer = Computer(forceWriteMode: true)
        var input = input

        for noun in 3..<99 {
            for verb in 3..<(99/2)+1 {
                input[1] = noun
                input[2] = verb
                computer.loadProgram(input)
                computer.reset()
                while !computer.isFinished {
                    computer.tick()
                }
                if computer.registerValue(for: 0) ?? -1 == expectedOutput {
                    return 100 * noun + verb
                }
            }
        }
        
        return -1
    }
}
