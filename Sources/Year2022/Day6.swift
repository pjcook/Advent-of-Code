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
    
    public func part1(_ input: String) -> Int {
        findStartSequence(input, length: 4)
    }
    
    public func part2(_ input: String) -> Int {
        findStartSequence(input, length: 14)
    }
    
    public func findStartSequence(_ input: String, length: Int) -> Int {
        for i in (length-1..<input.count) {
            if Set(input[i-length+1 ..< i+1]).count == length { return i + 1 }
        }
        return -1
    }
}
