import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        parse(input)
            .map({ extrapolateNextValue($0) })
            .reduce(0, +)
    }
    
    public func part2(_ input: [String]) -> Int {
        parse(input)
            .map({ extrapolatePreviousValue($0) })
            .reduce(0, +)
    }
}

extension Day9 {
    func extrapolateNextValue(_ items: [Int], depth: Int = 0) -> Int {
        var results = [Int]()
        for i in (1..<items.count) {
            results.append(items[i] - items[i-1])
        }
        
        guard !(results.first == 0 && results.last == 0) else { return 0 }
        let result = results.last! + extrapolateNextValue(results, depth: depth + 1)
        
        if depth == 0 {
            return result + items.last!
        } else {
            return result
        }
    }
    
    public func extrapolatePreviousValue(_ items: [Int], depth: Int = 0) -> Int {
        var results = [Int]()
        for i in (1..<items.count) {
            results.append(items[i] - items[i-1])
        }
        
        guard !(results.first == 0 && results.last == 0) else { return 0 }
        let result = results.first! - extrapolatePreviousValue(results, depth: depth + 1)
        
        if depth == 0 {
            return items.first! - result
        } else {
            return result
        }
    }
}

extension Day9 {
    func parse(_ input: [String]) -> [[Int]] {
        input.map {
            $0.components(separatedBy: " ").map {
                Int(String($0))!
            }
        }
    }
}
