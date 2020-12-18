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
        
        private func value(from element: Element) -> Int {
            switch element {
            case let .number(value): return value
            case let .calculation(calculation): return calculation.sum2()
            default: return 0
            }
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
                    reduced.append(last + value(from: operation))
                } else  if case .operation("*") = element {
                    reduced.append(value(from: operation))
                } else  if case .operation("+") = operation {
                    let anotherElement = elements[i+2]
                    reduced.append(value(from: element) + value(from: anotherElement))
                    i += 1
                } else {
                    reduced.append(value(from: element))
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
