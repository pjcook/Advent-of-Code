import Foundation
import StandardLibraries

public struct Day7Item {
    public enum ItemValue {
        case value(Int)
        case addition
        case multiply
        case concatenate
        
        public var value: Int {
            switch self {
            case .value(let value): return value
            default: return 0
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
    
    public func isValid(_ isPart2: Bool = false) -> Bool {
        let options = options(isPart2)
        for option in options {
            if evaluate(option) == result {
                return true
            }
        }
        return false
    }
    
    public func options(_ isPart2: Bool) -> [[ItemValue]] {
        calculateOptions(values, isFirst: true, isPart2: isPart2)
    }
    
    public func evaluate(_ items: [ItemValue]) -> Int {
        var items = items
        while items.count > 1 {
            let val1 = items[0].value
            let val2 = items[2].value
            let op = items[1]
            switch op {
            case .addition:
                items[0] = .value(val1 + val2)
            case .multiply:
                items[0] = .value(val1 * val2)
            case .concatenate:
                items[0] = .value(Int(String(val1) + String(val2))!)
            default:
                break
            }
            items.remove(at: 1)
            items.remove(at: 1)
        }
        
        return items.first!.value
    }
    
    public func calculateOptions(_ values: [Int], isFirst: Bool = false, isPart2: Bool) -> [[ItemValue]] {
        var values = values
        let next: ItemValue = .value(values.removeFirst())
        var results = [[ItemValue]]()
        if values.isEmpty {
            results.append([.addition, next])
            results.append([.multiply, next])
            if isPart2 {
                results.append([.concatenate, next])
            }
        } else {
            let options = calculateOptions(values, isPart2: isPart2)
            if isFirst {
                for option in options {
                    results.append([next] + option)
                }
            } else {
                for option in options {
                    results.append([.addition, next] + option)
                    results.append([.multiply, next] + option)
                    if isPart2 {
                        results.append([.concatenate, next] + option)
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
