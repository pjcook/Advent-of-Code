import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
        
    public enum Status: Equatable {
        case valid
        case invalid(Character)
        case incomplete([Character])
    }
    
    public func part1(_ input: [String]) -> Int {
        let scores = [
            Character(")"): 3,
            Character("]"): 57,
            Character("}"): 1197,
            Character(">"): 25137
            ]

        var count = 0
        for line in input {
            let result = parse(line)
            switch result {
            case .valid: break
            case .incomplete: break
            case .invalid(let c):
                count += scores[c]!
            }
        }
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        let scores = [
            Character("("): 1,
            Character("["): 2,
            Character("{"): 3,
            Character("<"): 4
            ]

        var finalScores = [Int]()
        for line in input {
            let result = parse(line)
            switch result {
            case .valid: break
            case .invalid: break
            case .incomplete(var remaining):
                var score = 0
                while !remaining.isEmpty {
                    let c = remaining.removeLast()
                    score *= 5
                    score += scores[c]!
                }
                finalScores.append(score)
            }
        }
        return finalScores.sorted()[finalScores.count / 2]
    }
    
    public let openers: [Character] = ["(", "[", "{", "<"]
    public let notRoundClose: [Character] = ["]", "}", ">"]
    public let notSquareClose: [Character] = [")", "}", ">"]
    public let notCurlyClose: [Character] = [")", "]", ">"]
    public let notArrowClose: [Character] = [")", "]", "}"]
    
    public func parse(_ input: String) -> Status {
        var found = [Character]()
        
        for c in input {
            if found.isEmpty {
                found.append(c)
            } else if
                found.last == "(" && c == ")"
                    || found.last == "[" && c == "]"
                    || found.last == "{" && c == "}"
                    || found.last == "<" && c == ">" {
                found.removeLast()
            } else if openers.contains(found.last!) && openers.contains(c) {
                found.append(c)
            } else if
                found.last == "(" && notRoundClose.contains(c)
                    || found.last == "[" && notSquareClose.contains(c)
                    || found.last == "{" && notCurlyClose.contains(c)
                    || found.last == "<" && notArrowClose.contains(c) {
                return .invalid(c)
            }
        }
        
        return found.isEmpty ? .valid : .incomplete(found)
    }
}
