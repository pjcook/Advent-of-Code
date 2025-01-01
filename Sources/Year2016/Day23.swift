//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day23 {
    public init() {}
    
    public func part1(_ input: [String], a: Int = 0) -> Int {
        let computer = BunnyComputer(a: a)
        let program = Day12.parse(input)
        computer.execute(program: program)
        return computer.a
    }
}
