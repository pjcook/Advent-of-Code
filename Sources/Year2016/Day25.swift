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
    
    public func part1(_ input: [String]) -> Int {
        let computer = BunnyComputer()
        let program = Day12.parse(input)
        var i = 0
        var toggle = false
        var count = 0
        var maxCount = 0
        
        func checkOutput(out: Int) -> Bool {
            if (toggle ? 1 : 0) == out {
                count += 1
                toggle.toggle()
                maxCount = max(maxCount, count)
                return true
            } else {
                return false
            }
        }
        
        computer.connectOutput(to: checkOutput)
        
        while count < 100 {
            computer.reset(a: i)
            computer.execute(program: program, with: 1000000)
            
            if count > 100 {
                return i
            }

            toggle = false
            count = 0
            i += 1
        }
        
        return -1
    }
}
