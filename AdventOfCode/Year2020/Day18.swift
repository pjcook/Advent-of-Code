import Foundation
//import StandardLibraries

public struct Day18 {
    public enum Token {
        case number(Int)
        case operation(Operator)
        case calculation(Calculation)
    }
    
    public enum Operator: Character {
        case multiplication = "*"
        case addition = "+"
    }
    
    public struct Calculation {
        public let elements: [Token]
        public init(elements: [Token]) {
            self.elements = elements
        }
    }
    
    public init() {}
    
    public func parse(_ input: [String]) -> [Calculation] {
        return input.map {
            var line = $0
            return processCalculation(&line)
        }
    }
    
    public func processCalculation(_ input: inout String) -> Calculation {
        var elements = [Token]()
        
        while !input.isEmpty {
            let c = input.removeFirst()
            switch c {
            case "+", "*": elements.append(.operation(Operator(rawValue: c)!))
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": elements.append(.number(Int(String(c))!))
            case "(":
                let calculation = processCalculation(&input)
                elements.append(.calculation(calculation))
                
            case ")":
                return Calculation(elements: elements)
                
            default: break
            }
        }
        
        return Calculation(elements: elements)
    }
    
    public func part1(_ input: [String]) -> Int {
        let calculations = parse(input)
        return calculations.reduce(0) { $0 + $1.sum_part1() }
    }
    
    public func part2(_ input: [String]) -> Int {
        let calculations = parse(input)
        return calculations.reduce(0) { $0 + $1.sum2_part2() }
    }
}

// MARK: - Part 1
extension Day18.Calculation {
    private func process(_ next: Int, total: Int, lastOperation: Day18.Operator?) -> Int {
        switch lastOperation {
        case .addition:
            return total + next
        case .multiplication:
            return total * next
        default:
            return next
        }
    }

    public func sum_part1() -> Int {
        var total: Int = 0, lastOperation: Day18.Operator?
        
        for element in elements {
            switch element {
            case let .number(value):
                total = process(value, total: total, lastOperation: lastOperation)
                
            case let .operation(value):
                lastOperation = value
                
            case let .calculation(calculation):
                total = process(calculation.sum_part1(), total: total, lastOperation: lastOperation)
                
            }
        }
        
        return total
    }
}

// MARK: - Part 2
extension Day18.Calculation {
    private func value(from element: Day18.Token) -> Int {
        switch element {
        case let .number(value): return value
        case let .calculation(calculation): return calculation.sum2_part2()
        default: return 0
        }
    }

    public func sum2_part2() -> Int {
        // do additions first
        var reduced = [Int](), i = 0
        
        while i < elements.count - 1 {
            let element = elements[i]
            let operation = elements[i+1]
            
            switch (element, operation) {
            case (.operation(.addition), .number(let value)):
                let last = reduced.removeLast()
                reduced.append(last + value)
                
            case (.operation(.addition), .calculation(let calculation)):
                let last = reduced.removeLast()
                reduced.append(last + calculation.sum2_part2())
                
            case (.operation(.multiplication), .number(let value)):
                reduced.append(value)
                
            case (.operation(.multiplication), .calculation(let calculation)):
                reduced.append(calculation.sum2_part2())
                
            case (.number(let value), .operation(.addition)):
                let anotherElement = elements[i+2]
                reduced.append(value + self.value(from: anotherElement))
                i += 1
                
            case (.calculation(let calculation), .operation(.addition)):
                let anotherElement = elements[i+2]
                reduced.append(calculation.sum2_part2() + value(from: anotherElement))
                i += 1
                
            case (.number(let value), _):
                reduced.append(value)
                
            case (.calculation(let calculation), _):
                reduced.append(calculation.sum2_part2())
                
            default:
                break
            }
            
            i += 2
        }
        
        if i < elements.count {
            reduced.append(value(from: elements.last!))
        }
        
        // handle multiplication
        return reduced.reduce(1, *)
    }
}
