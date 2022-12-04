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
            let elves = line.components(separatedBy: ["-",","]).compactMap(Int.init)
            if (elves[0] >= elves[2] && elves[1] <= elves[3]) || (elves[2] >= elves[0] && elves[3] <= elves[1]) {
                count += 1
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let elves = line.components(separatedBy: ["-",","]).compactMap(Int.init)
            if elves[1] < elves[2] || elves[0] > elves[3] {
                count += 1
            }
        }
        
        return input.count - count
    }
}

/*
 Quirky alternative solution using Sets, much less efficient than above
 */
extension Day4 {
    public func part1b(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let components = line.components(separatedBy: ["-",","])
            let elf1 = Set<Int>((Int(components[0])!...Int(components[1])!))
            let elf2 = Set<Int>((Int(components[2])!...Int(components[3])!))
            if elf1.isSubset(of: elf2) || elf1.isSuperset(of: elf2) {
                count += 1
            }
        }
        
        return count
    }
    
    public func part2b(_ input: [String]) -> Int {
        var count = 0
        
        for line in input {
            let components = line.components(separatedBy: ["-",","])
            let elf1 = Set<Int>((Int(components[0])!...Int(components[1])!))
            let elf2 = Set<Int>((Int(components[2])!...Int(components[3])!))
            if !elf1.intersection(elf2).isEmpty {
                count += 1
            }
        }
        
        return count
    }
}
