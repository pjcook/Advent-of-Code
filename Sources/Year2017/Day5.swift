//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day5 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        var list = input
        var count = 0
        var i = 0
        
        while (0..<input.count).contains(i) {
            count += 1
            let next = list[i]
            list[i] = next + 1
            i += next
        }
        
        return count
    }
    
    public func part2(_ input: [Int]) -> Int {
        var list = input
        var count = 0
        var i = 0
        
        while (0..<input.count).contains(i) {
            count += 1
            let next = list[i]
            list[i] = next + (next > 2 ? -1 : 1)
            i += next
        }
        
        return count
    }
}
