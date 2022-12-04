//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day4 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let elves = line.replacingOccurrences(of: ",", with: "-").components(separatedBy: "-").compactMap(Int.init)
            if (elves[0] >= elves[2] && elves[1] <= elves[3]) || (elves[2] >= elves[0] && elves[3] <= elves[1]) {
                count += 1
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let elves = line.replacingOccurrences(of: ",", with: "-").components(separatedBy: "-").compactMap(Int.init)
            if elves[1] < elves[2] || elves[0] > elves[3] {
                count += 1
            }
        }
        
        return input.count - count
    }
}
