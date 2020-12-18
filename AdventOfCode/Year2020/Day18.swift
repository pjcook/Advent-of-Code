import Foundation
//import StandardLibraries

public struct Day18 {
    public enum Element {
        case number(Int)
        case operation(Character)
        case calculation(Calculation)
    }
    
    public struct Calculation {
        public let elements: [Element]
        public init(elements: [Element]) {
            self.elements = elements
        }
        
        public func sum() -> Int {
            var total: Int?
            var lastOperation: Character?

            func process(_ next: Int) {
                if let operation = lastOperation, total != nil {
                    if operation == "+" {
                        total! += next
                    } else if operation == "*" {
                        total! *= next
                    }
                } else {
                    total = next
                }
            }
            
            for element in elements {
                switch element {
                case let .number(value):
                    process(value)
                    
                case let .operation(value):
                    lastOperation = value
                    
                case let .calculation(calculation):
                    process(calculation.sum())
                    
                }
            }
            
            return total ?? 0
        }
        
        public func sum2() -> Int {
            // do additions first
            var reduced = [Int]()
            var i = 0
            while i < elements.count - 1 {
                let element = elements[i]
                let operation = elements[i+1]
                
                if case .operation("+") = element {
                    let last = reduced.removeLast()
                    switch operation {
                    case let .number(value): reduced.append(value + last)
                    case let .calculation(calculation): reduced.append(calculation.sum2() + last)
                    default: break
                    }
                } else  if case .operation("*") = element {
                    switch operation {
                    case let .number(value): reduced.append(value)
                    case let .calculation(calculation): reduced.append(calculation.sum2())
                    default: break
                    }
                } else  if case .operation("+") = operation {
                    let anotherElement = elements[i+2]
                    i += 1
                    var value1 = 0, value2 = 0
                    switch element {
                    case let .number(value): value1 = value
                    case let .calculation(calculation): value1 = calculation.sum2()
                    default: break
                    }
                    switch anotherElement {
                    case let .number(value): value2 = value
                    case let .calculation(calculation): value2 = calculation.sum2()
                    default: break
                    }
                    reduced.append(value1 + value2)
                } else {
                    switch element {
                    case let .number(value): reduced.append(value)
                    case let .calculation(calculation): reduced.append(calculation.sum2())
                    default: break
                    }
                }
                i += 2
            }
            if i < elements.count {
                switch elements.last {
                case let .number(value): reduced.append(value)
                case let .calculation(calculation): reduced.append(calculation.sum2())
                default: break
                }
            }
            
            // handle multiplication
            return reduced.reduce(1, *)
        }
    }
    
    public init() {}
    
    public func parse(_ input: [String]) -> [Calculation] {
        return input.map {
            var line = $0.replacingOccurrences(of: " ", with: "")
            return processCalculation(&line)
        }
    }
    
    public func processCalculation(_ input: inout String) -> Calculation {
        var elements = [Element]()
        
        while !input.isEmpty {
            let c = input.removeFirst()
            switch c {
            case "+", "*": elements.append(.operation(c))
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
        return calculations.reduce(0) { $0 + $1.sum() }
    }
    
    public func part2(_ input: [String]) -> Int {
        let calculations = parse(input)
        return calculations.reduce(0) { $0 + $1.sum2() }
    }
}
