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
    
    public let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated().reduce([Character: Int]()) {
        var dict = $0
        dict[$1.element] = $1.offset + 1
        return dict
    }
    
    /*
     Each line can be split into two exact halves.
     Each half contains exactly 1 matching character.
     That matching character has an implicit value from the `lookup` table position + 1
     */
    public func part1(_ input: [String]) -> Int {
        input.reduce(0) {
            let hp = $1.count/2
            let a = Set($1.prefix(hp))
            let b = Set($1.suffix(hp))
            let match = Character(String(a.intersection(b)))
            return $0 + lookup[match]!
        }
    }
    
    /*
     The lines in the input are grouped into blocks of 3.
     There is exactly 1 matching character across each group of 3 lines.
     That matching character has an implicit value from the `lookup` table position + 1
     */
    public func part2(_ input: [String]) -> Int {
        stride(from: 0, to: input.count, by: 3)
            .reduce(0) {
                let a = Set(input[$1])
                let b = Set(input[$1+1])
                let c = Set(input[$1+2])
                let match = Character(String(a.intersection(b).intersection(c)))
                return $0 + lookup[match]!
            }
    }
}
