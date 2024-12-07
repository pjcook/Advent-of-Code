import Foundation
import StandardLibraries

public struct Day7Item {
    public enum ItemValue {
        case value(Int)
        case plus
        case multiply
        case concatenate
    }
    
    public let result: Int
    public let values: [Int]
    
    public init(_ input: String) {
        var components = input.components(separatedBy: CharacterSet(arrayLiteral: ":", " "))
        self.result = Int(components.removeFirst())!
        _ = components.removeFirst()
        self.values = components.map { Int($0)! }
    }
    
    public func isValid(_ isPart2: Bool = false) -> Bool {
        let options = options(isPart2)
        for option in options {
            if evaluate(option) == result {
                return true
            }
        }
        return false
    }
    
    public func options(_ isPart2: Bool) -> [String] {
        calculateOptions(values, isFirst: true, isPart2: isPart2)
    }
    
    public func evaluate(_ value: String) -> Int {
        var components = value.components(separatedBy: " ")
        while components.count > 1 {
            let val1 = Int(components[0])!
            let val2 = Int(components[2])!
            let op = components[1]
            switch op {
            case "+":
                components[0] = String(val1 + val2)
            case "*":
                components[0] = String(val1 * val2)
            case "|":
                components[0] = String(val1) + String(val2)
            default:
                break
            }
            components.remove(at: 1)
            components.remove(at: 1)
        }
        return Int(components.first!)!
    }
    
    public func calculateOptions(_ values: [Int], isFirst: Bool = false, isPart2: Bool) -> [String] {
        var values = values
        let next = values.removeFirst()
        var results = [String]()
        if values.isEmpty {
            results.append("+ \(next)")
            results.append("* \(next)")
            if isPart2 {
                results.append("| \(next)")
            }
        } else {
            let options = calculateOptions(values, isPart2: isPart2)
            if isFirst {
                for option in options {
                    results.append("\(next) \(option)")
                }
            } else {
                for option in options {
                    results.append("+ \(next) \(option)")
                    results.append("* \(next) \(option)")
                    if isPart2 {
                        results.append("| \(next) \(option)")
                    }
                }
            }
        }
        return results
    }
}

public struct Day7 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let items = input.map(Day7Item.init)
        var result = 0
        
        for item in items {
            if item.isValid() {
                result += item.result
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        let items = input.map(Day7Item.init)
        var result = 0
        
        for item in items {
            if item.isValid(true) {
                result += item.result
            }
        }
        
        return result
    }
}
