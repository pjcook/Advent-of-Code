//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated().reduce([Character: Int]()) {
        var dict = $0
        dict[$1.element] = $1.offset + 1
        return dict
    }
    
    /*
     Each line can be split into two exact halves.
     Each half contains exactly 1 matching character.
     That matching character has an implicit value from the `lookup` table position + 1
     */
    public func part1(_ input: [String]) -> Int {
        var total = 0
        for line in input {
            let hp = line.count/2
            let a = Set(line.prefix(hp))
            let b = Set(line.suffix(hp))
            let match = Character(String(a.intersection(b)))
            total += lookup[match]!
        }
        return total
    }
    
    /*
     The lines in the input are grouped into blocks of 3.
     There is exactly 1 matching character across each group of 3 lines.
     That matching character has an implicit value from the `lookup` table position + 1
     */
    public func part2(_ input: [String]) -> Int {
        var total = 0
        var pointer = 0
        let max = input.count

        while pointer < max {
            let a = Set(input[pointer])
            let b = Set(input[pointer+1])
            let c = Set(input[pointer+2])
            let match = Character(String(a.intersection(b).intersection(c)))
            total += lookup[match]!
            pointer += 3
        }
        
        return total
    }
}