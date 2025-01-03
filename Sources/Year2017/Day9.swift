//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day9 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        var index = 0
        return resolve(input, index: &index)
    }
    
    public func part2(_ input: String) -> Int {
        var index = 0
        return resolve2(input, index: &index)
    }
}

extension Day9 {
    func resolve(_ input: String, index: inout Int, depth: Int = 0) -> Int {
        var count = 0
        var foundGarbage = false
        var ignoreNext = false
        
        outerloop: while index < input.count {
            switch (ignoreNext, foundGarbage, input[index]) {
            case (false, false, "{"):
                index += 1
                count += resolve(input, index: &index, depth: depth + 1)

            case (false, false, "}"):
                break outerloop
                
            case (false, false, "<"):
                foundGarbage = true

            case (false, true, ">"):
                foundGarbage = false
                
            case (false, false, ">"):
                fatalError("oops")
                
            case (false, _, "!"):
                ignoreNext = true
                index += 1
                continue
                
            default:
                break
            }
            index += 1
            ignoreNext = false
        }
        
        return count + depth
    }
    
    func resolve2(_ input: String, index: inout Int, depth: Int = 0) -> Int {
        var count = 0
        var foundGarbage = false
        var ignoreNext = false
        
        outerloop: while index < input.count {
            switch (ignoreNext, foundGarbage, input[index]) {
            case (false, false, "{"):
                index += 1
                count += resolve2(input, index: &index, depth: depth + 1)

            case (false, false, "}"):
                break outerloop
                
            case (false, false, "<"):
                foundGarbage = true

            case (false, true, ">"):
                foundGarbage = false
                
            case (false, false, ">"):
                fatalError("oops")
                
            case (false, _, "!"):
                ignoreNext = true
                index += 1
                continue
                
            default:
                if foundGarbage, !ignoreNext {
                    count += 1
                }
            }
            index += 1
            ignoreNext = false
        }
        
        return count
    }
}
