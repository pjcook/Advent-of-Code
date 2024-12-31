//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Algorithms
import Foundation
import StandardLibraries

public struct Day21 {
    public init() {}
    
    public func part1(_ input: [String], value: String) -> String {
        let operations = input.map { Operation(rawValue: $0)! }
        var value = value.map(String.init)
        
        for op in operations {
            value = op.process(input: value)
        }
        
        return value.joined()
    }
    
    // Just brute force every permutation of possible inputs running through the original scrambling formula to find what input generates the output that you're trying to unscramble. Or you could try to reverse engineer the functions, but that didn't work out so good.
    public func part2(_ input: [String], value: String) -> String {
        let operations = input.map { Operation(rawValue: $0)! }
        
        for word in value.permutations() {
            var value2 = word.map(String.init)
            for op in operations {
                value2 = op.process(input: value2)
            }
            if value == value2.joined() {
                return String(word)
            }
        }
        
        return ""
    }
    
    /*
     - swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
     - swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the string).
     - rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
     - rotate based on position of letter X means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
     - reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
     - move position X to position Y means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
     */
    enum Operation {
        case swapPosition(Int, Int)
        case swapLetter(String, String)
        case rotateLeft(Int)
        case rotateRight(Int)
        case rotateBasedOnPosition(String)
        case reversePositions(Int, Int)
        case movePosition(Int, Int)
        
        func process(input: [String]) -> [String] {
            var output = input
            switch self {
            case let .swapPosition(x, y):
                output[y] = input[x]
                output[x] = input[y]
                
            case let .swapLetter(a, b):
                let x = input.firstIndex(of: a)!
                let y = input.firstIndex(of: b)!
                output[y] = input[x]
                output[x] = input[y]
                
            case let .rotateLeft(steps):
                output = input.suffix(input.count - steps) + input.prefix(steps)
                
            case let .rotateRight(steps):
                output = input.suffix(steps) + input.prefix(input.count - steps)
                
            case let .rotateBasedOnPosition(a):
                let index = input.firstIndex(of: a)!
                let steps = (1 + index + (index >= 4 ? 1 : 0)) % input.count
                output = input.suffix(steps) + input.prefix(input.count - steps)
                
            case let .reversePositions(x, y):
                for (i, j) in zip(x...y, (x...y).reversed()) {
                    output[i] = input[j]
                }
                
            case let .movePosition(x, y):
                output.remove(at: x)
                if y < output.count {
                    output.insert(input[x], at: y)
                } else {
                    output.append(input[x])
                }
            }
            return output
        }
        
        init?(rawValue: String) {
            let parts = rawValue.split(separator: " ")
            switch parts[0] {
            case "swap":
                switch parts[1] {
                case "letter":
                    self = .swapLetter(String(parts[2]), String(parts[5]))
                    
                case "position":
                    self = .swapPosition(Int(parts[2])!, Int(parts[5])!)
                    
                default:
                    fatalError("oops")
                }
                
            case "rotate":
                switch parts[1] {
                case "right":
                    self = .rotateRight(Int(parts[2])!)
                    
                case "left":
                    self = .rotateLeft(Int(parts[2])!)
                    
                case "based":
                    self = .rotateBasedOnPosition(String(parts[6]))
                    
                default:
                    fatalError("oops")
                }
                
            case "reverse":
                self = .reversePositions(Int(parts[2])!, Int(parts[4])!)
                
            case "move":
                self = .movePosition(Int(parts[2])!, Int(parts[5])!)
                
            default:
                fatalError("oops")
            }
        }
    }
}
