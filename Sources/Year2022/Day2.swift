//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day2 {
    public init() {}
    
    enum RockPaperScissors: String {
        case rock = "A"
        case paper = "B"
        case scissors = "C"
        case rockP2 = "X"
        case paperP2 = "Y"
        case scissorsP2 = "Z"
        
        func score(_ p2: RockPaperScissors) -> Int {
            switch (self, p2) {
            case (.rock, .rockP2): return 1 + RockPaperScissors.drawPoints
            case (.rock, .paperP2): return 2 + RockPaperScissors.winPoints
            case (.rock, .scissorsP2): return 3
            case (.paper, .rockP2): return 1
            case (.paper, .paperP2): return 2 + RockPaperScissors.drawPoints
            case (.paper, .scissorsP2): return 3 + RockPaperScissors.winPoints
            case (.scissors, .rockP2): return 1 + RockPaperScissors.winPoints
            case (.scissors, .paperP2): return 2
            case (.scissors, .scissorsP2): return 3 + RockPaperScissors.drawPoints
            default: return 1
            }
        }
        
        static var winPoints: Int = 6
        static var drawPoints: Int = 3
    }
    
    public func part1(_ input: [String]) -> Int {
        parse(input).reduce(0, { $0 + $1.2 })
    }
    
    func parse(_ input: [String]) -> [(RockPaperScissors, RockPaperScissors, Int)] {
        var results = [(RockPaperScissors, RockPaperScissors, Int)]()
        
        for line in input {
            guard !line.isEmpty else { continue }
            let components = line.components(separatedBy: " ")
            let p1 = RockPaperScissors(rawValue: components[0])!
            let p2 = RockPaperScissors(rawValue: components[1])!
            let result = (p1, p2, p1.score(p2))
            results.append(result)
        }
        
        return results
    }
    
    enum RockPaperScissors2: String {
        case rock = "A"
        case paper = "B"
        case scissors = "C"
        
        func score(_ expectedResult: ExtectedResult) -> Int {
            requiredForExpectation(expectedResult).points + expectedResult.points
        }
        
        func requiredForExpectation(_ expectedResult: ExtectedResult) -> RockPaperScissors2 {
            switch (self, expectedResult) {
            case (.rock, .lose): return .scissors
            case (.rock, .draw): return .rock
            case (.rock, .win): return .paper
            case (.paper, .lose): return .rock
            case (.paper, .draw): return .paper
            case (.paper, .win): return .scissors
            case (.scissors, .lose): return .paper
            case (.scissors, .draw): return .scissors
            case (.scissors, .win): return .rock
            }
        }
        
        var points: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }
        
        static var winPoints: Int = 6
        static var drawPoints: Int = 3
    }
    
    enum ExtectedResult: String {
        case lose = "X"
        case draw = "Y"
        case win = "Z"
        
        var points: Int {
            switch self {
            case .lose: return 0
            case .draw: return 3
            case .win: return 6
            }
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        parse2(input).reduce(0, { $0 + $1.2 })
    }
    
    func parse2(_ input: [String]) -> [(RockPaperScissors2, ExtectedResult, Int)] {
        var results = [(RockPaperScissors2, ExtectedResult, Int)]()
        
        for line in input {
            guard !line.isEmpty else { continue }
            let components = line.components(separatedBy: " ")
            let p1 = RockPaperScissors2(rawValue: components[0])!
            let p2 = ExtectedResult(rawValue: components[1])!
            let result = (p1, p2, p1.score(p2))
            results.append(result)
        }
        
        return results
    }
}
