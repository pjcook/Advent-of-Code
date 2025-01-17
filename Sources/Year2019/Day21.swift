//
//  Day21.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day21 {
    public init() {}
    private let computer = Computer(forceWriteMode: false)
    private var springScript = [Int]()
    private var finished = false
    private var isPart2 = false
    private var row = ""
    var finalOutput = 0
    
    public func part1(_ input: [Int], springScriptProgram: String) -> Int {
        finished = false
        isPart2 = false
        computer.reset()
        computer.delegate = self
        computer.loadProgram(input)
        springScript = convertSpringScript(springScriptProgram)
        row = ""
        finalOutput = 0
        
        while !finished {
            computer.tick()
        }
        
        return finalOutput
    }
    
    private func convertSpringScript(_ program: String) -> [Int] {
        program.compactMap {
            if let ascii = $0.asciiValue {
                return Int(ascii)
            }
            return nil
        }
    }
}

extension Day21: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        guard !springScript.isEmpty else {
            return -1
        }
        let value = springScript.removeFirst()
        return value
    }
    
    public func computerFinished(id: Int) {
        finished = true
    }
    
    public func processOutput(id: Int, value: Int) {
        guard let asciiValue = value.toAscii() else {
            print("OUTPUT:", value)
            finalOutput = value
            return
        }
        guard asciiValue != "\n" else {
            print(row)
            row = ""
            return
        }
        row += asciiValue
    }
}
