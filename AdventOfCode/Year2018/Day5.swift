import Foundation
import StandardLibraries

public struct Day5 {
    public func part1(input: String) -> String {
        var input = input
        var remaining = [input.removeFirst()]

        while !input.isEmpty {
            var c: String.Element? = input.removeFirst()
            
            while react(a: remaining.last, b: c) {
                remaining.removeLast()
                if !input.isEmpty {
                    c = input.removeFirst()
                } else {
                    c = remaining.last
                }
            }
            
            if let c = c {
                remaining.append(c)
            }
        }
        
        return String(remaining)
    }
    
    public func react(a: String.Element?, b: String.Element?) -> Bool {
        guard let a = a, let b = b else { return false }
        return a.lowercased() == b.lowercased() && a != b
    }
    
    public func part1_daniel(input: String) -> Int {
        input
            .reduce(into: [Character]()) { result, character in
                if let previous = result.last, previous.isPolarOpposite(to: character) {
                    result.removeLast()
                } else {
                    result.append(character)
                }
            }
            .count
    }
    
    public func part2_daniel(input: String) -> Int {
        let uniqueCharacters = Set(input.lowercased())
        
        return uniqueCharacters.map { character in
            return input
                .replacingOccurrences(of: String(character), with: "", options: .caseInsensitive)
                .reduce(into: [Character]()) { result, character in
                    if let previous = result.last, previous.isPolarOpposite(to: character) {
                        result.removeLast()
                    } else {
                        result.append(character)
                    }
                }
                .count
        }
        .sorted()
        .first ?? 0
    }
}

public extension Sequence where Element == Character {
    var reducingPolymer: [Character] {
        return reduce(into: []) { result, character in
            if let previous = result.last, previous.isPolarOpposite(to: character) {
                result.removeLast()
            } else {
                result.append(character)
            }
        }
    }
}

public extension Character {
    var lowercased: Character {
        return Character(String(self).lowercased())
    }
    
    func isPolarOpposite(to character: Character) -> Bool {
        return self != character && self.lowercased == character.lowercased
    }
}
