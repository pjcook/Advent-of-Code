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
    
    public func part1(_ input: [Int]) -> Int {
        var i = 1
        var count = 0
        
        while i < input.count {
            if input[i-1] == input[i] {
                count += input[i]
            }
            i += 1
        }
        
        if input.first == input.last {
            count += input[0]
        }
        
        return count
    }
    
    public func part2(_ input: [Int]) -> Int {
        var dx = input.count / 2
        var i = 0
        var count = 0
        
        while i < input.count {
            if input[i] == input[(i + dx) % input.count] {
                count += input[i]
            }
            i += 1
        }
        
        return count
    }
}
