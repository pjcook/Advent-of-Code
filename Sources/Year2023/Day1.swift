import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var sum = 0
        for line in input {
            let numbers = line.compactMap {
                Int(String($0))
            }
            sum += (10 * numbers.first!) + numbers.last!
        }
        return sum
    }
    
    public func part2(_ input: [String]) -> Int {
        var sum = 0
        for line in input {
            let numbers = line.extractNumbers()
            sum += (10 * numbers.first!) + numbers.last!
        }
        return sum
    }
}

extension String {
    public func extractNumbers() -> [Int] {
        var results = [Int]()
        let numbers = [
            "one": 1,
            "two": 2,
            "three": 3,
            "four": 4,
            "five": 5,
            "six": 6,
            "seven": 7,
            "eight": 8,
            "nine": 9
        ]
        
        let validCharacters: [Character] = ["o", "t", "f", "s", "e", "n"]
        
        var content = self
        
        while !content.isEmpty {
            if validCharacters.contains(content.first!) {
                for number in numbers {
                    if content.hasPrefix(number.key) {
                        results.append(number.value)
                    }
                }
            } else if let item = Int(String(content.first!)) {
                results.append(item)
            }
            content.removeFirst()
        }
        
        return results
    }
}
