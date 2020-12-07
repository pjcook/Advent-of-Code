import Foundation

public struct Day7 {
    public func part1(_ input: [String], color: String = "shiny gold") -> Int {
        let rules = Set<Rule>(input.map(Rule.init))
        var canContainShineyGoldBag = 0
        
        for rule in rules {
            if rule.contains(color: color, rules: rules) {
                canContainShineyGoldBag += 1
            }
        }
        
        return canContainShineyGoldBag
    }
    
    public func part2(_ input: [String], color: String = "shiny gold") -> Int {
        let rules = Set<Rule>(input.map(Rule.init))
        let rule = rules.first(where: { $0.color == color })!
        return rule.nestedBagCount(rules: rules) - 1
    }
    
    public func part1_v2(_ input: [String], color: String = "shiny gold") -> Int {
        let rules = Set<Rule>(input.map(Rule.init))
        return (rules.first(where: { $0.color == color })?.parents(rules).count ?? 1)
    }
}

public extension Day7 {
    static let ruleRegex = try! NSRegularExpression(pattern: "^([a-z]+)\\s([a-z]+)")
    static let contentRegex = try! NSRegularExpression(pattern: "([0-9]+)\\s([a-z]+)\\s([a-z]+)")
    static let contentIDRegex = try! NSRegularExpression(pattern: "([0-9]+)")
    static let contentColorRegex = try! NSRegularExpression(pattern: "([a-z]+)\\s([a-z]+)")
    
    class Rule {
        public let color: String
        public let contents: [ContentBag]

        public init(_ input: String) {
            let range = NSRange(location: 0, length: input.utf16.count)
            let rule = Day7.ruleRegex.firstMatch(in: input, options: [], range: range)!
            let bagContents = Day7.contentRegex.matches(in: input, options: [], range: range)
            color = String(input[Range(rule.range, in: input)!])
            contents = bagContents.map { ContentBag(String(input[Range($0.range, in: input)!])) }
        }
        
        private var containsColor: [String: Bool] = [:]
        public func contains(color: String, rules: Set<Rule>) -> Bool {
            if let result = containsColor[color] {
                return result
            } else {
                for content in contents {
                    if content.color == color {
                        containsColor[color] = true
                        return true
                    } else if rules.first(where: { $0.color == content.color })?.contains(color: color, rules: rules) ?? false {
                        containsColor[color] = true
                        return true
                    }
                }
                containsColor[color] = false
                return false
            }
        }
        
        private var nestedContentCount: Int = -1
        public func nestedBagCount(rules: Set<Rule>) -> Int {
            if nestedContentCount == -1 {
                nestedContentCount = contents.reduce(1, { result, bag in
                    let rule = rules.first { r in
                        r.color == bag.color
                    }!
                    return result + (rule.nestedBagCount(rules: rules) * bag.count)
                })
            }
            return nestedContentCount
        }
        
        public func parents(_ rules: Set<Rule>) -> Set<Rule> {
            var parents = Set<Rule>(rules.filter({ $0.contents.contains(where: { $0.color == color }) }))
            guard !parents.isEmpty else { return [] }
            
            for rule in parents {
                parents = parents.union(rule.parents(rules))
            }
            return parents
        }
    }
    
    struct ContentBag: Hashable {
        public let color: String
        public let count: Int
        public init(_ input: String) {
            var input = input
            count = Int(String(input.removeFirst()))!
            _ = input.removeFirst()
            color = input
            
            // 50% slower than above
//            let range = NSRange(location: 0, length: input.utf16.count)
//            let countMatch = Day7.contentIDRegex.firstMatch(in: input, options: [], range: range)!
//            let colorMatch = Day7.contentColorRegex.firstMatch(in: input, options: [], range: range)!
//            count = Int(String(input[Range(countMatch.range, in: input)!]))!
//            color = String(input[Range(colorMatch.range, in: input)!])
        }
    }
}

extension Day7.Rule: Equatable {
    public static func == (lhs: Day7.Rule, rhs: Day7.Rule) -> Bool {
        lhs.color == rhs.color
    }
}

extension Day7.Rule: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(contents)
    }
}
