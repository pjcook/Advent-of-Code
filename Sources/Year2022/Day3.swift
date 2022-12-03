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
    
    public let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".map { $0 }
    public func valueOf(_ char: Character) -> Int {
        lookup.firstIndex(of: char)! + 1
    }
    
    public func part1(_ input: [String]) -> Int {
        var total = 0
        for line in input {
            let hp = line.count/2
            let a = Set(line[0..<hp])
            let b = Set(line[hp..<line.count])
            let match = Character(String(a.intersection(b)))
            total += valueOf(match)
        }
        return total
    }
    
    public func part2(_ input: [String]) -> Int {
        var lines = input
        var total = 0
        
        while !lines.isEmpty {
            let a = Set(lines.removeFirst())
            let b = Set(lines.removeFirst())
            let c = Set(lines.removeFirst())
            let match = Character(String(a.intersection(b).intersection(c)))
            total += valueOf(match)
        }
        
        return total
    }
}
