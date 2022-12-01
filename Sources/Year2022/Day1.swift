//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day1 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let elves = parse(input)
        return elves
            .map {
                $0.reduce(0, { $0 + $1 })
            }
            .sorted(by: { $0 > $1})
            .first!
    }
    
    public func part2(_ input: [String]) -> Int {
        let elves = parse(input)
        return elves
            .map {
                $0.reduce(0, { $0 + $1 })
            }
            .sorted(by: { $0 > $1})
            .prefix(3)
            .reduce(0, +)
    }
    
    func parse(_ input: [String]) -> [[Int]] {
        var output = [[Int]]()
        var elf = [Int]()
        
        for line in input {
            guard !line.isEmpty else {
                output.append(elf)
                elf = []
                continue
            }
            if let calories = Int(line) {
                elf.append(calories)
            }
        }
        
        if !elf.isEmpty {
            output.append(elf)
        }
        return output
    }
    
    public func part1b(_ input: [String]) -> Int {
        var maxCalories = 0
        var elf: Int = 0
        
        for line in input {
            guard !line.isEmpty else {
                if elf > maxCalories {
                    maxCalories = elf
                }
                elf = 0
                continue
            }
            if let calories = Int(line) {
                elf += calories
            }
        }
        
        if elf > maxCalories {
            maxCalories = elf
        }
        
        return maxCalories
    }
    
    public func part2b(_ input: [String]) -> Int {
        var maxCalories = [Int]()
        var elf: Int = 0
        
        for line in input {
            guard !line.isEmpty else {
                maxCalories.append(elf)
                elf = 0
                continue
            }
            if let calories = Int(line) {
                elf += calories
            }
        }
        
        if elf > 0 {
            maxCalories.append(elf)
        }
        
        return maxCalories
            .sorted(by: { $0 > $1})
            .prefix(3)
            .reduce(0, +)
    }
}
