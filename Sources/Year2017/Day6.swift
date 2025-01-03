//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day6 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        var list = input
        var count = 0
        var seen: Set<[Int]> = []
        
        while !seen.contains(list) {
            seen.insert(list)
            var remainder = findNext(list)
            var i = list.firstIndex(of: remainder)!
            list[i] = 0
            while remainder > 0 {
                i += 1
                if i == list.count {
                    i = 0
                }
                list[i] += 1
                remainder -= 1
            }
            count += 1
        }
        
        return count
    }
    
    public func part2(_ input: [Int]) -> Int {
        var list = input
        var count = 0
        var seen: [[Int]: Int] = [:]
        
        while seen[list] == nil {
            seen[list] = count
            var remainder = findNext(list)
            var i = list.firstIndex(of: remainder)!
            list[i] = 0
            while remainder > 0 {
                i += 1
                if i == list.count {
                    i = 0
                }
                list[i] += 1
                remainder -= 1
            }
            count += 1
        }
        
        return count - seen[list]!
    }
}

extension Day6 {
    func findNext(_ list: [Int]) -> Int {
        list.sorted().last!
    }
}
