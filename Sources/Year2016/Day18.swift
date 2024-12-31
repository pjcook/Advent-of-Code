//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day18 {
    public init() {}
    
    public func part1(_ input: String, rowsToGenerate: Int) -> Int {
        var previousRow = input.map({ Tile(rawValue: $0)! })
        var count = previousRow.reduce(0) { $0 + ($1 == .safe ? 1 : 0) }
        var i = 1
        
        while i < rowsToGenerate {
            var row = [Tile]()
            for i in 0..<previousRow.count {
                let l = i > 0 ? previousRow[i-1] : .safe
                let c = previousRow[i]
                let r = i < previousRow.count-1 ? previousRow[i+1] : .safe
                if isTrap(l: l, c: c, r: r) {
                    row.append(.trap)
                } else {
                    row.append(.safe)
                    count += 1
                }
            }
            previousRow = row
            i += 1
        }
        
        return count
    }
    
    enum Tile: Character, CustomDebugStringConvertible {
        case trap = "^"
        case safe = "."
        
        var debugDescription: String {
            String(rawValue)
        }
    }
}

extension Day18 {
    func isTrap(l: Tile, c: Tile, r: Tile) -> Bool {
        (l == .trap && c == .trap && r == .safe) ||
        (l == .safe && c == .trap && r == .trap) ||
        (l == .trap && c == .safe && r == .safe) ||
        (l == .safe && c == .safe && r == .trap)
    }
}
