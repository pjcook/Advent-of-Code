//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        parse(input)
            .compactMap {
                isValid($0) ? $0 : nil
            }
            .count
    }
    
    public func part2(_ input: [String]) -> Int {
        let values = parse(input)
        var count = 0
        var i = 2
        
        while i < values.count {
            for j in 0..<3 {
                if isValid([
                    values[i-2][j],
                    values[i-1][j],
                    values[i][j]
                ]) {
                    count += 1
                }
            }
            
            i += 3
        }
                
        return count
    }
    
    func isValid(_ values: [Int]) -> Bool {
        let o = values.sorted(by: <)
        return o[0] + o[1] > o[2]
    }
}

extension Day3 {
    func parse(_ input: [String]) -> [[Int]] {
        var values = [[Int]]()
        
        for line in input {
            values.append(line
                .replacingOccurrences(of: "    ", with: " ")
                .replacingOccurrences(of: "   ", with: " ")
                .replacingOccurrences(of: "  ", with: " ")
                .split(separator: " ")
                .map { Int($0)! }
            )
        }
        
        return values
    }
}
