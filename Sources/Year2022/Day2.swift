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
    
    enum RockPaperScissors: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
        
        init?(rawValue: String) {
            switch rawValue {
            case "A": self = .rock
            case "B": self = .paper
            case "C": self = .scissors
            case "X": self = .rock
            case "Y": self = .paper
            case "Z": self = .scissors
            default: return nil
            }
        }
        
        func scoreForPart1(_ p2: RockPaperScissors) -> Int {
            p2.rawValue + GameResult(self, p2).rawValue
        }
        
        func scoreForPart2(_ expectedResult: GameResult) -> Int {
            requiredForExpectation(expectedResult).rawValue + expectedResult.rawValue
        }
        
        func requiredForExpectation(_ expectedResult: GameResult) -> RockPaperScissors {
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
        
        static var winPoints: Int = 6
        static var drawPoints: Int = 3
    }
    
    enum GameResult: Int {
        case lose = 0
        case draw = 3
        case win = 6
        
        init?(rawValue: String) {
            switch rawValue {
            case "X": self = .lose
            case "Y": self = .draw
            case "Z": self = .win
            default: return nil
            }
        }
        
        init(_ p1: RockPaperScissors, _ p2: RockPaperScissors) {
            switch (p1, p2) {
            case (.rock, .rock): self = .draw
            case (.rock, .paper): self = .win
            case (.rock, .scissors): self = .lose
            case (.paper, .rock): self = .lose
            case (.paper, .paper): self = .draw
            case (.paper, .scissors): self = .win
            case (.scissors, .rock): self = .win
            case (.scissors, .paper): self = .lose
            case (.scissors, .scissors): self = .draw
            }
        }
    }
    
    public func part1(_ input: [String]) -> Int {
        var results = 0
        
        for line in input {
            guard !line.isEmpty else { continue }
            let components = line.components(separatedBy: " ")
            let p1 = RockPaperScissors(rawValue: components[0])!
            let p2 = RockPaperScissors(rawValue: components[1])!
            results += p1.scoreForPart1(p2)
        }
        
        return results
    }
    
    public func part2(_ input: [String]) -> Int {
        var results = 0
        
        for line in input {
            guard !line.isEmpty else { continue }
            let components = line.components(separatedBy: " ")
            let p1 = RockPaperScissors(rawValue: components[0])!
            let p2 = GameResult(rawValue: components[1])!
            results += p1.scoreForPart2(p2)
        }
        
        return results
    }
}
