//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        parse(input).reduce(0) {
            $0 + ($1.max()! - $1.min()!)
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        var count = 0
        for list in parse(input) {
            let sorted = list.sorted(by: >)
            innerLoop: for a in sorted {
                for b in sorted where b < a && b > 0 {
                    let a1 = a / b
                    let a2 = Double(a) / Double(b)
                    if Double(a1) == a2 {
                        count += a / b
                        print(a, b)
                        break innerLoop
                    }
                }
            }
        }
        
        return count
    }
}

extension Day2 {
    func parse(_ input: [String]) -> [[Int]] {
        var results = [[Int]]()

        for line in input {
            results.append(
                line
                .replacingOccurrences(of: "  ", with: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .split(separator: " ")
                .map({ Int($0)! })
            )
        }
        
        return results
    }
}
