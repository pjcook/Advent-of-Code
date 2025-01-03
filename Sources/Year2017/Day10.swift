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
        let lengths = (input.map { $0.asciiValue! } + [17, 31, 73, 47, 23]).compactMap(Int.init)
        
        var skipSize = 0
        var i = 0
        var list = Array(0...255)

        for _ in 0..<64 {
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
        }
        
        var denseHash = [Int]()
        i = 0
        var subset = [Int]()
        while i < list.count {
            subset.append(list[i])
            i += 1
            if i % 16 == 0 {
                denseHash.append(subset[1...].reduce(subset[0], { $0 ^ $1 }))
                subset = []
            }
        }
        
        return denseHash.map({ String($0, radix: 16).pad(to: 2) }).joined()
    }
}
