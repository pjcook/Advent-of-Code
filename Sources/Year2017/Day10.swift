//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
    
    public func part1(_ lengths: [Int], _ list: [Int]) -> Int {
        var skipSize = 0
        var i = 0
        var list = list

        for l in lengths {
            if i + l < list.count {
                list.replaceSubrange(i..<i+l, with: list[i..<i+l].reversed())
            } else {
                let remainder = l + i - list.count
                let reversed = Array(Array(list[i...] + list[..<remainder]).reversed())
                let remainderIndex = (reversed.count - remainder)
                list.replaceSubrange(i..., with: reversed[..<remainderIndex])
                list.replaceSubrange(..<remainder, with: reversed[remainderIndex...])
            }
            i += skipSize + l
            i = i % list.count
            skipSize += 1
        }
        
        return list[0] * list[1]
    }
    
    public func part2(_ input: String) -> String {
        input.knotHash()
    }
}
