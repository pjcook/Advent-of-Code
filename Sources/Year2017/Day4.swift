//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var count = 0
        
        outerloop: for line in input {
            var words = Set<String>()
            for word in line.split(separator: " ").map(String.init) {
                if words.contains(word) {
                    continue outerloop
                }
                words.insert(word)
            }
            count += 1
        }
        
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        var count = 0
        
        outerloop: for line in input {
            var words = Set<String>()
            for word in line.split(separator: " ").map(String.init) {
                let sortedWord = String(word.sorted())
                if words.contains(sortedWord) {
                    continue outerloop
                }
                words.insert(sortedWord)
            }
            count += 1
        }
        
        return count
    }
}
