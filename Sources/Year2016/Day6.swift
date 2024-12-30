//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    public func part1(_ input: [String]) -> String {
        let cols = input[0].count
        var columns = Array(repeating: [String: Int](), count: cols)
        
        for row in input {
            for i in 0..<cols {
                let c = String(row[i])
                var dict = columns[i]
                dict[c] = dict[c, default: 0] + 1
                columns[i] = dict
            }
        }
        
        var word = ""
        
        for col in columns {
            word.append(col.sorted(by: { $0.value > $1.value }).first!.key)
        }
        
        return word
    }
    
    public func part2(_ input: [String]) -> String {
        let cols = input[0].count
        var columns = Array(repeating: [String: Int](), count: cols)
        
        for row in input {
            for i in 0..<cols {
                let c = String(row[i])
                var dict = columns[i]
                dict[c] = dict[c, default: 0] + 1
                columns[i] = dict
            }
        }
        
        var word = ""
        
        for col in columns {
            word.append(col.sorted(by: { $0.value < $1.value }).first!.key)
        }
        
        return word
    }
}
