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
        for i in (3..<input.count) {
            let values = Set([input[i], input[i-1], input[i-2], input[i-3]])
            if values.count == 4 { return i + 1 }
        }
        return -1
    }
    
    public func part2(_ input: String) -> Int {
        for i in (13..<input.count) {
            let values = Set([input[i], input[i-1], input[i-2], input[i-3], input[i-4], input[i-5], input[i-6], input[i-7], input[i-8], input[i-9], input[i-10], input[i-11], input[i-12], input[i-13]])
            if values.count == 14 { return i + 1 }
        }
        return -1
    }
}
