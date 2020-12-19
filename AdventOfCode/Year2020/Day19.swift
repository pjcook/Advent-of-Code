import Foundation
import StandardLibraries

public struct Day19 {
    public init() {}
    
    public func part1(rules: [Int: Rule], messages: [String]) -> Int {
        let patterns = Set(buildRule(0, rules: rules))
        var count = 0
        for message in messages {
            count += patterns.contains(message) ? 1 : 0
        }
        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        return 0
    }
}

public extension Day19 {
    func buildList(list: [Int], rules: [Int: Rule]) -> [String] {
        var results = [String]()
        for i in list {
            guard !results.isEmpty else {
                results = buildRule(i, rules: rules)
                continue
            }
            let r = results
            results.removeAll()
            for result in r {
                for item in buildRule(i, rules: rules) {
                    results.append(result + item)
                }
            }
        }
        
        return results
    }
    
    func buildRule(_ id: Int, rules: [Int: Rule]) -> [String] {
        let rule = rules[id]!

        switch rule {
        case let .character(c):
            return [c]

        case let .list(list):
            return buildList(list: list, rules: rules)
            
        case let .optionalLists(list1, list2):
            return buildList(list: list1, rules: rules) + buildList(list: list2, rules: rules)
        }
    }
}

public extension Day19 {
    func parse(_ input: [String]) throws -> ([Int: Rule], [String]) {
        var input = input
        var rules = [Int:Rule]()
        var line = input.removeFirst()
        while !line.isEmpty {
            let comp1 = line.components(separatedBy: ":")
            let id = Int(String(comp1[0]))!
            let comp2 = comp1[1].components(separatedBy: " ").filter { !$0.isEmpty }
            if comp2.contains("|") {
                var list1 = [Int]()
                var list2 = [Int]()
                var useList1 = true
                for item in comp2 {
                    if item == "|" {
                        useList1 = false
                    } else {
                        let value = Int(item)!
                        if useList1 {
                            list1.append(value)
                        } else {
                            list2.append(value)
                        }
                    }
                }
                rules[id] = .optionalLists(list1, list2)
            } else if ["\"a\"","\"b\""].contains(comp2[0]) {
                rules[id] = .character(comp2[0].replacingOccurrences(of: "\"", with: ""))
            } else {
                rules[id] = .list(comp2.map { Int($0)! })
            }
            line = input.removeFirst()
        }
        
        var messages = [String]()
        while !input.isEmpty {
            line = input.removeFirst()
            messages.append(line)
        }
        return (rules, messages)
    }
}

public extension Day19 {
    enum Rule {
        case character(String)
        case list([Int])
        case optionalLists([Int], [Int])
    }
}
