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
        let components = input.components(separatedBy: CharacterSet(arrayLiteral: ":", " "))
        self.result = Int(components.first!)!
        self.values = components[2...].map { Int($0)! }
    }
    
    public func isValid(with operators: [Operators]) -> Bool {
        var results = [Int]()
        results.append(values.first!)
        for next in values[1...] {
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
        evaluate(input, operators: [.addition, .multiply])
    }
    
    public func part2(_ input: [String]) -> Int {
        evaluate(input, operators: [.addition, .multiply, .concatenate])
    }
    
    private func evaluate(_ input: [String], operators: [Day7Item.Operators]) -> Int {
        input
            .map(Day7Item.init)
            .reduce(0) { result, item in
                item.isValid(with: operators) ? result + item.result : result
            }
    }
}
