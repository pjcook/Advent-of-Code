//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public class Day9 {
    public init() {}
    
    private var cache = [String: Int]()
    
    public func part1(_ input: String) -> Int {
        var output = ""
        var i = 0
        
        while i < input.count {
            if input[i] == "(" {
                var a = ""
                i += 1
                while input[i] != "x" {
                    a += input[i]
                    i += 1
                }
                i += 1
                var b = ""
                while input[i] != ")" {
                    b += input[i]
                    i += 1
                }
                i += 1
                let distance = Int(a)!
                let times = Int(b)!
                let value = String(input[i...i+distance-1])
                i += distance
                for _ in 0..<times {
                    output.append(value)
                }
            } else {
                output.append(String(input[i]))
                i += 1
            }
        }        
        
        return output.count
    }
    
    public func part2(_ input: String) -> Int {
        findDecompressedLength(of: input)
    }
    
    func findDecompressedLength(of input: String) -> Int {
        if let value = cache[input] {
            return value
        }

        var i = 0
        var count = 0
        
        while i < input.count {
            if input[i] == "(" {
                var output = ""
                var a = ""
                i += 1
                while input[i] != "x" {
                    a += input[i]
                    i += 1
                }
                i += 1
                var b = ""
                while input[i] != ")" {
                    b += input[i]
                    i += 1
                }
                i += 1
                let distance = Int(a)!
                let times = Int(b)!
                let value = String(input[i...i+distance-1])
                i += distance
                for _ in 0..<times {
                    output.append(value)
                }
                
                if output.contains("(") {
                    count += findDecompressedLength(of: output)
                } else {
                    count += output.count
                }
            } else {
                count += 1
                i += 1
            }
        }
        
        cache[input] = count
        return count
    }
}
