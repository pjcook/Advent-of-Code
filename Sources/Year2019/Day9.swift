//
//  Day9.swift
//  Year2019
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day9 {
    public init() {}
    private var systemID: Int = 1
    
    public func part1(_ input: [Int], code: Int) -> Int {
        systemID = code
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        
        computer.loadProgram(input)
        
        while !computer.isFinished {
            computer.tick()
        }
        
        return computer.output ?? -1
    }
}

extension Day9: ComputerDelegate {
    public func processOutput(id: Int, value: Int) {}
    
    public func readInput(id: Int) -> Int { systemID }
    
    public func computerFinished(id: Int) {}
}
