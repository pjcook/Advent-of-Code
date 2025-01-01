//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let computer = BunnyComputer()
        let program = Day12.parse(input)
        computer.execute(program: program)
        return computer.a
    }
    
    public func part2(_ input: [String]) -> Int {
        let computer = BunnyComputer(a: 0, b: 0, c: 1, d: 0)
        let program = Day12.parse(input)
        computer.execute(program: program)
        return computer.a
    }
}

extension Day12 {
    static func parse(_ input: [String]) -> [BunnyComputerInstruction] {
        input.map(BunnyComputerInstruction.init)
    }
}
