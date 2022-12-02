//
//  Day2_Lam.swift
//  AdventOfCode
//
//  Created by PJ on 02/12/2022.
//

import Foundation

// CREDITS: https://github.com/laposheureux/AdventOfCode22/blob/main/Day2.swift

fileprivate let lookupTable: [String: Int] = [
    "A X": 4,
    "A Y": 8,
    "A Z": 3,
    "B X": 1,
    "B Y": 5,
    "B Z": 9,
    "C X": 7,
    "C Y": 2,
    "C Z": 6
]

fileprivate let lookupTablePart2: [String: Int] = [
    "A X": 3,
    "A Y": 4,
    "A Z": 8,
    "B X": 1,
    "B Y": 5,
    "B Z": 9,
    "C X": 2,
    "C Y": 6,
    "C Z": 7
]

public final class Day2Lamo {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        return input
            .reduce(0) { partialResult, play in
                return partialResult + lookupTable[play, default: 0]
            }
    }

    public func part2(_ input: [String]) -> Int {
        return input
            .reduce(0) { partialResult, play in
                return partialResult + lookupTablePart2[play, default: 0]
            }
    }
}
