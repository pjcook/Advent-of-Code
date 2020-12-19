import Foundation
import StandardLibraries

public class Day19 {
    private var ruleCache = [Int: [String]]()

    public init() {}
    
    public func part1(rules: [Int: Rule], messages: [String]) -> Int {
        let patterns = Set(buildRule(0, rules: rules))
        // print(patterns.count) // 2097152
        var count = 0
        for message in messages {
            count += patterns.contains(message) ? 1 : 0
        }
        return count
    }
    
    public func part2(rules: [Int: Rule], messages: [String]) -> Int {
        print(Date(), "Start")
        var rules2 = rules
        rules2[500] = .character("x")
        rules2[501] = .character("y")
        rules2[8] = .optionalLists([42], [42, 500])
        rules2[11] = .optionalLists([42, 31], [42, 501, 31])
        print(Date(), "Build rules")
        let patterns = Set(buildRule(0, rules: rules2))
        
        var basicPatterns = [String]()
        var patternsX = [String]()
        var patternsY = [String]()
        var patternsXY = [String]()
        var multiPattern = [String]()
        
        print(Date(), "Split patterns")
        for pattern in patterns {
            var x = 0
            var y = 0
            for c in pattern {
                if c == "x" {
                    x += 1
                } else if c == "y" {
                    y += 1
                }
            }
            switch (x, y) {
            case (0,0): basicPatterns.append(pattern)
            case (1,0): patternsX.append(pattern)
            case (0,1): patternsY.append(pattern)
            case (1,1): patternsXY.append(pattern)
            default: multiPattern.append(pattern)
            }
        }
        
        var matches = [String]()
        var messages = Set(messages)

        var temp = Set<String>()
        
        for pattern in patternsXY {
            let indexX = pattern.firstIndex(of: "x")!
            let prefix = pattern.prefix(upTo: indexX)

            let indexY = pattern.firstIndex(of: "y")!
            let suffix = pattern.suffix(from: pattern.index(indexY, offsetBy: 1))

            let filteredMessages = messages.filter { $0.hasPrefix(prefix) && $0.hasSuffix(suffix) }
            
            for message in filteredMessages {
                temp.insert(message)
                messages.remove(message)
            }
        }
        
        for pattern in basicPatterns {
            let filteredMessages = messages.filter { $0 == pattern }
            for message in filteredMessages {
                temp.insert(message)
                messages.remove(message)
            }
        }
        
        return temp.count
        
        
        
        
        // match basic
        print(Date(), "Match basic")
        var maxMessageLength = messages.reduce(0) { $0 > $1.count ? $0 : $1.count }
        var filteredPatterns = basicPatterns.filter { $0.count < maxMessageLength }
        for message in messages {
            if filteredPatterns.contains(message) {
                matches.append(message)
                messages.remove(message)
            }
        }
        
        // matchX
        print(Date(), "Match X")
        maxMessageLength = messages.reduce(0) { $0 > $1.count ? $0 : $1.count }
        filteredPatterns = patternsX.filter { $0.count < maxMessageLength }

        for pattern in filteredPatterns {
            let parts = pattern.components(separatedBy: "x")
            let filteredMessages = messages.filter { $0.hasPrefix(parts[0]) && $0.hasSuffix(parts[1]) }
            
            for message in filteredMessages {
                var remainder = message
                remainder.removeFirst(parts[0].count)
                remainder.removeLast(parts[1].count)
                if checkRemainder42(remainder) {
                    matches.append(message)
                    messages.remove(message)
                }
            }
            
            if messages.isEmpty {
                break
            }
        }
        
        // matchY
        print(Date(), "Build rule 4231")
        var pattern4231 = [String]()
        let rule42 = ruleCache[42]!
        let rule31 = ruleCache[31]!
        for x in rule42 {
            for y in rule31 {
                pattern4231.append(x + y)
            }
        }
        ruleCache[4231] = pattern4231
        
        print(Date(), "Match Y")
        maxMessageLength = messages.reduce(0) { $0 > $1.count ? $0 : $1.count }
        filteredPatterns = patternsY.filter { $0.count < maxMessageLength }
        
        for pattern in filteredPatterns {
            let parts = pattern.components(separatedBy: "y")
            let filteredMessages = messages.filter { $0.hasPrefix(parts[0]) && $0.hasSuffix(parts[1]) }
            
            for message in filteredMessages {
                var remainder = message
                remainder.removeFirst(parts[0].count)
                remainder.removeLast(parts[1].count)
                if checkRemainder11(remainder) {
                    matches.append(message)
                    messages.remove(message)
                }
            }
            
            if messages.isEmpty {
                break
            }
        }
        
        // matchXY
        print(Date(), "Match XY")
        maxMessageLength = messages.reduce(0) { $0 > $1.count ? $0 : $1.count }
        filteredPatterns = patternsXY.filter { $0.count < maxMessageLength }
        
        for pattern in filteredPatterns {
            let indexX = pattern.firstIndex(of: "x")!
            let prefix = pattern.prefix(upTo: indexX)

            let indexY = pattern.firstIndex(of: "y")!
            let suffix = pattern.suffix(from: pattern.index(indexY, offsetBy: 1))

            let filteredMessages = messages.filter { $0.hasPrefix(prefix) && $0.hasSuffix(suffix) }
            
            for message in filteredMessages {
                var remainder = message
                remainder.removeFirst(prefix.count)
                remainder.removeLast(suffix.count)
                let substring = pattern[pattern.index(indexX, offsetBy: 1)..<indexY]
                let parts = remainder.components(separatedBy: substring)

                if
                    parts.count == 2,
                    !parts[0].isEmpty,
                    !parts[1].isEmpty,
                    checkRemainder42(parts[0]),
                    checkRemainder11(parts[1])
                {
                    matches.append(message)
                    messages.remove(message)
                }
            }
            
            if messages.isEmpty {
                break
            }
        }
        
        print(matches)
        return matches.count
    }
    
    var cacheRemainder42 = [String: Bool]()
    private func checkRemainder42(_ remainder: String) -> Bool {
        if let cache = cacheRemainder42[remainder] {
            return cache
        }

        let originalRemainder = remainder
        let rule42 = Set(ruleCache[42]!)
        if rule42.contains(remainder) {
            cacheRemainder42[originalRemainder] = true
            return true
        }
        
        var remainder = remainder
        while !remainder.isEmpty {
            var matched = false
            for pattern in rule42 {
                if remainder.hasPrefix(pattern) {
                    remainder.removeFirst(pattern.count)
                    if remainder.isEmpty {
                        cacheRemainder42[originalRemainder] = true
                        return true
                    } else {
                        matched = true
                        continue
                    }
                }
            }
            if remainder.isEmpty {
                cacheRemainder42[originalRemainder] = true
                return true
            }
            if !matched {
                cacheRemainder42[originalRemainder] = false
                return false
            }
        }
        cacheRemainder42[originalRemainder] = false
        return false
    }
    
    var cacheRemainder11 = [String: Bool]()
    private func checkRemainder11(_ remainder: String) -> Bool {
        if let cache = cacheRemainder11[remainder] {
            return cache
        }
        
        let originalRemainder = remainder
        let rule42 = ruleCache[42]!
        let rule31 = ruleCache[31]!
        let rule4231 = ruleCache[4231]!
        var remainder = remainder
        mainLoop: while !remainder.isEmpty {
            var matched = false

            // match left rule
            for pattern in rule4231 {
                if remainder.hasPrefix(pattern) {
                    remainder.removeFirst(pattern.count)
                    if remainder.isEmpty {
                        cacheRemainder11[originalRemainder] = true
                        return true
                    } else {
                        matched = true
                        continue mainLoop
                    }
                }
            }
            
            // match right rule
            outerLoop: for left in rule42 {
                for right in rule31 {
                    guard
                        remainder.count >= left.count + right.count,
                        remainder.hasPrefix(left),
                        remainder.hasSuffix(right)
                    else { continue }
                    
                    var check = remainder
                    check.removeFirst(left.count)
                    check.removeLast(right.count)
                    if checkRemainder11(check) {
                        remainder.removeFirst(check.count)
                        matched = true
                        break outerLoop
                    }
                }
            }
            
            if remainder.isEmpty {
                cacheRemainder11[originalRemainder] = true
                return true
            }
            if !matched {
                cacheRemainder11[originalRemainder] = false
                return false
            }
        }
        cacheRemainder11[originalRemainder] = false
        return false
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
        if let cached = ruleCache[id] {
            return cached
        }
        
        let rule = rules[id]!
        var result = [String]()
        
        switch rule {
        case let .character(c):
            result = [c]

        case let .list(list):
            result = buildList(list: list, rules: rules)
            
        case let .optionalLists(list1, list2):
            result = buildList(list: list1, rules: rules) + buildList(list: list2, rules: rules)
        }

        ruleCache[id] = result
        return result
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

extension Day19.Rule: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .character(value): return "Character:" + value
        case let .list(values): return "List:" + values.map { String($0) }.joined()
        case let .optionalLists(values1, values2): return "Optional List:" + values1.map { String($0) }.joined() + " | " +  values2.map { String($0) }.joined()
        }
    }
}

extension Day19.Rule: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}
