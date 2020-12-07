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
}

public extension Day7 {
    class Rule {
        public let color: String
        public let contents: [ContentBag]

        public init(_ input: String) {
            let components = input.components(separatedBy: "bags contain")
            color = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let contentItems = components[1].components(separatedBy: ",")
            if contentItems[0] == " no other bags." {
                contents = []
            } else {
                contents = contentItems.map(ContentBag.init)
            }
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
    }
    
    struct ContentBag: Hashable {
        public let color: String
        public let count: Int
        public init(_ input: String) {
            var components = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            components.removeLast()
            count = Int(components.removeFirst())!
            color = components.joined(separator: " ")
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
