//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day21 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let (monkeys, calculations) = parse(input)
        return calculate(monkeys: monkeys, calculations: calculations)["root"]!
    }
    
    public func part2(_ input: [String]) -> Int {
        let (monkeys, calculations) = parse(input)
        var resolved = calculate(monkeys: monkeys, calculations: calculations)
        let (correctId, wrongId, trail) = findCorrectRootId(monkeys: monkeys, calculations: calculations, resolved: resolved)
        
        let value = resolved[correctId]!
        resolved[wrongId] = value
        
        var queue = [String]()
        queue.append(wrongId)
        
        while let id = queue.popLast() {
            if id == "humn" {
                return resolved["humn"]!
            }
            let (_, id1, sym, id2) = calculations.first(where: { $0.0 == id })!
            let result = resolved[id]!
            if trail.contains(id1) {
                let value2 = resolved[id2]!
                switch sym {
                case "+": resolved[id1] = result - value2
                case "*": resolved[id1] = result / value2
                case "/": resolved[id1] = result * value2
                case "-": resolved[id1] = result + value2
                default: assert(false)
                }
                queue.append(id1)
            } else {
                let value1 = resolved[id1]!
                switch sym {
                case "+": resolved[id2] = result - value1
                case "*": resolved[id2] = result / value1
                case "/": resolved[id2] = value1 / result
                case "-": resolved[id2] = value1 - result
                default: assert(false)
                }
                queue.append(id2)
            }
        }
        
        return resolved["humn"]!
    }
}

extension Day21 {
    public typealias Monkeys = [String: Int]
    public typealias Calculation = (String, String, Character, String)
    public typealias Calculations = [Calculation]
    
    public func parse(_ input: [String]) -> (Monkeys, Calculations) {
        var monkeys = Monkeys()
        var calculations = Calculations()
        
        for line in input {
            if line.count < 12 {
                let parts = line.components(separatedBy: " ")
                monkeys[String(parts[0].prefix(4))] = Int(parts[1])!
            } else {
                let parts = line.components(separatedBy: " ")
                calculations.append((String(parts[0].prefix(4)), parts[1], Character(parts[2]), parts[3]))
            }
        }
        
        return (monkeys, calculations)
    }
    
    public func calculate(monkeys: Monkeys, calculations: Calculations) -> Monkeys {
        var monkeys = monkeys
        var calculations = calculations
        while !calculations.isEmpty {
            let (monkey, id1, sym, id2) = calculations.removeFirst()
            if let value1 = monkeys[id1], let value2 = monkeys[id2] {
                switch sym {
                case "+": monkeys[monkey] = value1 + value2
                case "*": monkeys[monkey] = value1 * value2
                case "/": monkeys[monkey] = value1 / value2
                case "-": monkeys[monkey] = value1 - value2
                default: assert(false)
                }
            } else {
                calculations.append((monkey, id1, sym, id2))
            }
        }
        return monkeys
    }
    
    public func findCorrectRootId(monkeys: Monkeys, calculations: Calculations, resolved: Monkeys) -> (String, String, Set<String>) {
        var trail = Set<String>()
        var queue = calculations.filter({ $0.1 == "humn" || $0.3 == "humn" })
        trail.insert("humn")

        while let (monkey, id1, _, id2) = queue.popLast() {
            if monkey == "root" {
                if !trail.contains(id1) {
                    return (id1, id2, trail)
                } else {
                    return (id2, id1, trail)
                }
            }

            trail.insert(monkey)
            queue.append(contentsOf: calculations.filter({ $0.1 == monkey || $0.3 == monkey }))
        }
        assert(false)
        return ("","",trail)
    }
}
