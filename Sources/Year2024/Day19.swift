import Foundation
import StandardLibraries

public class Day19 {
    public init() {}
    var cache: [String: Bool] = [:]
    var cache2: [String: Int] = [:]
    
    public func part1(_ input: [String]) -> Int {
        let (patterns, sequences) = parse(input)
        return sequences.reduce(0) { $0 + (isValidPattern(patterns, sequence: $1) ? 1 : 0) }
    }
    
    public func part2(_ input: [String]) -> Int {
        let (patterns, sequences) = parse(input)
        return sequences.reduce(0) { $0 + checkValidPattern(patterns, sequence: $1) }
    }
    
    typealias Pattern = String
    typealias Sequence = String
}

extension Day19 {
    func parse(_ input: [String]) -> ([Pattern], [Sequence]) {
        let patterns = input[0].split(separator: ", ").map(String.init)
        let sequences = input[2...].map { String($0) }
        return (patterns, sequences)
    }
    
    func isValidPattern(_ patterns: [Pattern], sequence: Sequence) -> Bool {
        if let result = cache[sequence] {
            return result
        }
                
        for pattern in patterns where sequence.hasPrefix(pattern) {
            var next = sequence
            next = String(next.dropFirst(pattern.count))
            if next.isEmpty {
                cache[sequence] = true
                return true
            }
            
            if isValidPattern(patterns, sequence: next) {
                cache[sequence] = true
                return true
            }
        }
        
        return false
    }
    
    func checkValidPattern(_ patterns: [Pattern], sequence: Sequence) -> Int {
        if let result = cache2[sequence] {
            return result
        }
        
        var count = 0
        for pattern in patterns where sequence.hasPrefix(pattern) {
            var next = sequence
            next = String(next.dropFirst(pattern.count))
            if next.isEmpty {
                count += 1
            } else {
                count += checkValidPattern(patterns, sequence: next)
            }
        }

        cache2[sequence] = count
        return count
    }
}
