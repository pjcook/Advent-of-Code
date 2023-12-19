import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let (workflow, parts) = parse(input)
        var result = 0

        for part in parts {
            if case .accept = process(part: part, workflow: workflow, id: "in") {
                result += part.value
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        let (workflow, _) = parse(input)
        var rules = extractRules(workflow, soFar: [], id: "in")
        var result = 0
        
        // Remove the noise
        for i in (0..<rules.count) {
            rules[i] = rules[i].filter {
                $0.instrumentType != .any
            }
        }
        
        // consolidate the rules
        var index = 1
        while index < rules.count {
            cleanUpRules(&rules, index: &index)
        }
        
        rules.forEach { print($0) }

        // Calculate the final answer
        for rule in rules {
            var values = [Int]()
            
            for instrument in InstrumentType.allCases {
                guard instrument != .any else { continue }
                let options = rule.filter {
                    $0.instrumentType == instrument
                }
                
                if options.count == 0 {
                    values.append(4000)
                } else if options.count == 1 {
                    if options[0].calculation == .lessThan {
                        values.append(options[0].value - 1)
                    } else {
                        values.append(4000 - options[0].value)
                    }
                } else {
                    // s<1393:A, m>1711:A, m<2864:A, s>617:A, a>2135:A, m>2362:A, s<1105:A, x<2523:A, m>2689:A, x>1092:A, x<2044:R, m<2797:R, s>782:A
                    // if all calculations e..g < or > are the same then
                    //    if calculation == < then use smallest value - 1
                    //    else use 4000 - largest value
                    // else smallest lessThan - largest greaterThan
                    let calculation = options[0].calculation
                    if options.reduce(true, { $0 && $1.calculation == calculation }) {
                        let value = options.map({ $0.value }).sorted().first!
                        if calculation == .lessThan {
                            values.append(value - 1)
                        } else {
                            values.append(4000 - value)
                        }
                    } else {
                        let lessThanOptions = options.filter { $0.calculation == .lessThan }.map({ $0.value }).sorted()
                        let moreThanOptions = options.filter { $0.calculation == .greaterThan }.map({ $0.value }).sorted()
                        values.append(lessThanOptions.first! - 1 - moreThanOptions.last!)
                    }
                }
            }
            
            result += values.reduce(1, *)
        }
        return result
    }
    
    func cleanUpRules(_ rules: inout [[Rule]], index: inout Int) {
        guard index > 0 else {
            index += 1
            return
        }
        
        let rule = rules[index]
        var previous = rules[index-1]
        let e1 = previous.last!
        let e2 = rule.last!
        if e1.instrumentType == e2.instrumentType && e1.calculation != e2.calculation && abs(e1.value - e2.value) == 1 {
            _ = previous.removeLast()
            rules[index-1] = previous
            rules.remove(at: index)
            index -= 1
            cleanUpRules(&rules, index: &index)
        } else {
            index += 1
        }
    }
    
    func extractRules(_ workflow: [String: Workflow], soFar: [Rule], id: String) -> [[Rule]] {
        var rules = [[Rule]]()
        let work = workflow[id]!
        var soFar = soFar
        
        for rule in work.rules {
            switch rule.result {
                case .accept:
                    switch rule.instrumentType {
                        case .any:
                            soFar.append(rule)
                            rules.append(soFar)
                        default:
                            var next = soFar
                            next.append(rule)
                            rules.append(next)
                            
                            soFar.append(rule.inverted())
                    }
                    
                case .reject:
                    soFar.append(rule.inverted())
                    
                case let .map(nextID):
                    var next = soFar
                    next.append(rule)
                    rules.append(contentsOf: extractRules(workflow, soFar: next, id: nextID))
                    
                    soFar.append(rule.inverted())
            }
        }
        
        return rules
    }
    
    func process(part: Part, workflow: [String: Workflow], id: String) -> Result {
        let work = workflow[id]!
        
        var result: Result?
        outerloop: for rule in work.rules {
            switch rule.instrumentType {
                case .cool:
                    if rule.calculation.process(value: part.x, check: rule.value) {
                        result = rule.result
                        break outerloop
                    }
                case .musical:
                    if rule.calculation.process(value: part.m, check: rule.value) {
                        result = rule.result
                        break outerloop
                    }
                case .aerodynamic:
                    if rule.calculation.process(value: part.a, check: rule.value) {
                        result = rule.result
                        break outerloop
                    }
                case .shiny:
                    if rule.calculation.process(value: part.s, check: rule.value) {
                        result = rule.result
                        break outerloop
                    }
                case .any:
                    result = rule.result
                    break outerloop
            }
        }
        
        switch result {
            case .accept:
                return .accept
                
            case .reject:
                return .reject
                
            case let .map(nextID):
                return process(part: part, workflow: workflow, id: nextID)
                
            default:
                assertionFailure("oops")
                return .reject
        }
    }
    
    enum InstrumentType: String, CaseIterable {
        case cool = "x"
        case musical = "m"
        case aerodynamic = "a"
        case shiny = "s"
        case any = ""
    }
    
    enum Calculation: String, CaseIterable {
        case greaterThan = ">"
        case lessThan = "<"
        case none = ""
        
        func process(value: Int, check: Int) -> Bool {
            switch self {
                case .greaterThan:
                    value > check
                case .lessThan:
                    value < check
                case .none:
                    false
            }
        }
        
        var inverse: Calculation {
            switch self {
                case .greaterThan: .lessThan
                case .lessThan: .greaterThan
                case .none: .none
            }
        }
    }
    
    enum Result: Equatable, CustomStringConvertible {
        case accept
        case reject
        case map(String)
        
        static func from(_ value: String) -> Result {
            switch value {
            case "A":
                Result.accept
                
            case "R":
                Result.reject
                
            default:
                Result.map(value)
            }
        }
        
        var description: String {
            switch self {
                case .reject: "R"
                case .accept: "A"
                case let .map(id): id
            }
        }
    }
    
    // ex{x>10:one,m<20:two,a>30:R,A}
    struct Workflow {
        let id: String      // ex
        let rules: [Rule]   // x>10:one  m<20:two  a>30:R  A
    }
    
    struct Rule: CustomStringConvertible {
        let instrumentType: InstrumentType
        let calculation: Calculation
        let value: Int
        let result: Result
        
        init(instrumentType: InstrumentType, calculation: Calculation, value: Int, result: Result) {
            self.instrumentType = instrumentType
            self.calculation = calculation
            self.value = value
            self.result = result
        }
        
        init(result: Result) {
            self.instrumentType = .any
            self.calculation = .none
            self.value = 0
            self.result = result
        }
        
        var description: String {
            "\(instrumentType.rawValue)\(calculation.rawValue)\(value):\(result)"
        }
        
        func inverted() -> Rule {
            let newCalculation = calculation.inverse
            let newValue = newCalculation == .greaterThan ? value - 1 : value + 1
            switch result {
                case .accept:
                    return Rule(instrumentType: instrumentType, calculation: newCalculation, value: newValue, result: .reject)
                case .reject:
                    return Rule(instrumentType: instrumentType, calculation: newCalculation, value: newValue, result: .accept)
                default:
                    return Rule(instrumentType: instrumentType, calculation: newCalculation, value: newValue, result: .accept)
            }
        }
    }
    
    struct Part {
        let x: Int
        let m: Int
        let a: Int
        let s: Int
        
        var value: Int {
            x + m + a + s
        }
    }
}

extension Day19 {
    func parse(_ input: [String]) -> ([String: Workflow], [Part]) {
        var workflows = [String: Workflow]()
        let lists = input.split(separator: "")
        
        for line in lists[0] {
            let components = line.components(separatedBy: CharacterSet(arrayLiteral: "{", ",", "}")).dropLast()
            let id = components[0]
            var rules = [Rule]()
            outerloop: for i in (1..<components.count) {
                let item = components[i]
                let parts = item.components(separatedBy: ":")
                
                // handle final result
                if parts.count == 1 {
                    let result = Result.from(parts[0])
                    let rule = Rule(instrumentType: .any, calculation: .none, value: 0, result: result)
                    rules.append(rule)
                    continue
                }
                
                // x>10:one
                let result = Result.from(parts[1])
                for calc in Calculation.allCases {
                    let lr = parts[0].components(separatedBy: calc.rawValue)
                    if lr.count == 2 {
                        let rule = Rule(instrumentType: InstrumentType(rawValue: lr[0]) ?? .any, calculation: calc, value: Int(lr[1])!, result: result)
                        rules.append(rule)
                        continue outerloop
                    }
                }
                
                assertionFailure("oops")
            }
            let workflow = Workflow(id: id, rules: rules)
            workflows[id] = workflow
        }
        
        var parts = [Part]()
        for line in lists[1] {
            let components = line.dropFirst().dropLast().components(separatedBy: CharacterSet(arrayLiteral: "=", ","))
            let part = Part(x: Int(components[1])!, m: Int(components[3])!, a: Int(components[5])!, s: Int(components[7])!)
            parts.append(part)
        }
        
        return (workflows, parts)
    }
}
