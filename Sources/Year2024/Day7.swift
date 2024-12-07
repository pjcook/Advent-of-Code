import Foundation
import StandardLibraries

public struct Day7Item {
    public enum Operators {
        case addition
        case multiply
        case concatenate

        func eval(_ a: Int, _ b: Int) -> Int {
            switch self {
            case .addition: return a + b
            case .multiply: return a * b
            case .concatenate: return Int(String(a) + String(b))!
            }
        }
    }
    
    public let result: Int
    public let values: [Int]
    
    public init(_ input: String) {
        var components = input.components(separatedBy: CharacterSet(arrayLiteral: ":", " "))
        self.result = Int(components.removeFirst())!
        _ = components.removeFirst()
        self.values = components.map { Int($0)! }
    }
    
    public func isValid(with operators: [Operators]) -> Bool {
        var remaining = self.values
        var results = [Int]()
        results.append(remaining.removeFirst())
        while !remaining.isEmpty {
            let next = remaining.removeFirst()            
            var newResults = [Int]()
            for result in results {
                for op in operators {
                    newResults.append(op.eval(result, next))
                }
            }
            results = newResults
        }
        
        return results.first(where: { $0 == self.result }) != nil
    }
}

public struct Day7 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let items = input.map(Day7Item.init)
        var result = 0
        
        for item in items {
            if item.isValid(with: [.addition, .multiply]) {
                result += item.result
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        let items = input.map(Day7Item.init)
        var result = 0
        
        for item in items {
            if item.isValid(with: [.addition, .multiply, .concatenate]) {
                result += item.result
            }
        }
        
        return result
    }
}
