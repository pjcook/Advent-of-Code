//
//  Day17.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day17 {
    public init() {}
    private var row = ""
    private var rows = [String]()
    private var finished = false
    private var isPart2 = false
    private var inputInstructions: [Int] = []
    private var inputInstructionPointer = 0
    private var storeOutput = true
    private var collectedDust = 0
    
    public func part1(_ input: [Int]) -> Int {
        row = ""
        rows = []
        finished = false
        isPart2 = false
        storeOutput = true
        
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        
        while !finished {
            computer.tick()
        }
        
        var result = 0
        let grid = Grid<String>(rows)
        for i in 0..<grid.items.count {
            let point = grid.point(for: i)
            if point.cardinalNeighbors(in: grid, matching: ["#"]).count == 4 {
                result += point.x * point.y
            }
        }
                
        return result
    }
    
    public func part2(_ input: [Int], program: String) -> Int {
        row = ""
        rows = []
        finished = false
        isPart2 = true
        storeOutput = false
        inputInstructions = program.toAscii()
        inputInstructionPointer = 0
        
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        
        while !finished {
            computer.tick()
        }
                        
        return collectedDust
    }
}

extension Day17: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        guard isPart2, inputInstructionPointer < inputInstructions.count else { return 0 }
        let value = inputInstructions[inputInstructionPointer]
        inputInstructionPointer += 1
        if inputInstructionPointer == inputInstructions.count {
            storeOutput = true
        }
        return value
    }
    
    public func computerFinished(id: Int) {
        finished = true
    }
    
    public func processOutput(id: Int, value: Int) {
        guard storeOutput else {
            switch value {
            case 10: print(row); row = ""
            default: row.append(value.toAscii()!)
            }
            return
        }
        
        switch value {
        case 35: row.append("#")
        case 46: row.append(".")
        case 10:
            if !row.isEmpty {
                rows.append(row)
                row = ""
            }
        case 94: row.append("^")
        case 118: row.append("v")
        case 60: row.append("<")
        case 62: row.append(">")
        default:
            row.append(value.toAscii()!)
            collectedDust = value
        }
    }
}
