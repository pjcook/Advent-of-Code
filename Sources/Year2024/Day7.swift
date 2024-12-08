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
            case .concatenate:
                var scale = 1
                switch b {
                case 0...9: scale = 10
                case 10...99: scale = 100
                case 100...999: scale = 1000
                default: break
                }
                return a * scale + b  // Int(String(a) + String(b))!
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
        // do initial checks up to the end
        for next in values[1..<(values.count-1)] {
            var newResults = [Int]()
            for result in results {
                for op in operators {
                    let val = op.eval(result, next)
                    if val <= self.result {
                        newResults.append(val)
                    }
                }
            }
            results = newResults
        }
        
        // then check the end separately so you can exit early
        let next = values.last!
        for result in results {
            for op in operators {
                if op.eval(result, next) == self.result {
                    return true
                }
            }
        }
        
        return false
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
