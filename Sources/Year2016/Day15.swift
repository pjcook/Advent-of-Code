//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day15 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let discs = input.map(Disc.init)
        var i = 0
        
        while !check(discs: discs, time: i) {
            i += 1
        }
        
        return i
    }
    
    struct Disc {
        let id: Int
        let positions: Int
        let position: Int
        
        init(_ value: String) {
            // Disc #1 has 5 positions; at time=0, it is at position 4.
            let values = value
                .replacingOccurrences(of: "#", with: "")
                .replacingOccurrences(of: ".", with: "")
                .split(separator: " ")
            self.id = Int(values[1])!
            self.positions = Int(values[3])!
            self.position = Int(values[11])!
        }
    }
}

extension Day15 {
    func check(discs: [Disc], time: Int) -> Bool {
        discs.reduce(0, { $0 + ((time + $1.id + $1.position) % $1.positions) }) == 0
    }
}
