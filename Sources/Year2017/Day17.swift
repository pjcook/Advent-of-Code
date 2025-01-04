//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day17 {
    public init() {}
    
    public func part1(_ input: Int) -> Int {
        var list = [0]
        var position = 0
        
        for i in 1...2017 {
            position = (position + input) % list.count + 1
            if position == list.count {
                list.append(i)
            } else {
                list.insert(i, at: position)
            }
        }

        return list[(position + 1) % list.count]
    }
    
    public func part2(_ input: Int) -> Int {
        var list = [0]
        var position = 0
        var zeroIndex = 0
        var lastValue: Int?
        
        for i in 1...50000000 {
            position = (position + input) % i + 1
            if position == zeroIndex {
                zeroIndex += 1
            } else if position == zeroIndex + 1 {
                lastValue = i
            }
        }

        return lastValue!
    }
}
