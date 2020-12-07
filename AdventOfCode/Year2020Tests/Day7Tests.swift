import XCTest
import InputReader
@testable import Year2020

class Day7Tests: XCTestCase {
    let input = try! Input("Day7.input", Year2020.bundle)
    
    func test_part1() {
        measure {
            let day = Day7()
            XCTAssertEqual(224, day.part1(input.lines))
        }
    }
    
    func test_part2() {
        measure {
            let day = Day7()
            XCTAssertEqual(1488, day.part2(input.lines))
        }
    }
    
    func test_part1_v2() {
        measure {
            let day = Day7()
            XCTAssertEqual(224, day.part1_v2(input.lines))
        }
    }
    
    func test_part1_v2_example() {
        let input = """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
        """
        measure {
            let day = Day7()
            XCTAssertEqual(4, day.part1_v2(input.lines))
        }
    }
    
    func test_parsingToRules() {
        measure {
            let rules = input.lines.map(Day7.Rule.init)
            XCTAssertEqual(594, rules.count)
        }
    }
    
    func test_parsingToRules_chris() {
        measure {
            let rules = getBags(input: input.lines)
            XCTAssertEqual(594, rules.count)
        }
    }
    
    struct BagRule {
        let bag: String
        let amount: Int
    }
    
    func getBags(input: [String]) -> [String: [BagRule]] {
            var bagsAndRules: [String: [BagRule]] = [:]
            
            input.forEach { line in
                let words = line.components(separatedBy: " ")
                let bag = words.prefix(2).joined()
                var rules: [BagRule] = []
                for index in stride(from: 0, through: words.count, by: 4) {
                    if (index + 4) < words.count {
                        if let amount = Int(words[index + 4]) {
                            let bag = words[index + 5] + words[index + 6]
                            rules.append(BagRule(bag: bag, amount: amount))
                        }
                    }
                }
                
                bagsAndRules[bag] = rules
            }
            
            return bagsAndRules
        }
    
    func test_part1_example() {
        let input = """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
        """
        let day = Day7()
        XCTAssertEqual(4, day.part1(input.lines))
    }
    
    func test_part2_example() {
        let input = """
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
        """
        let day = Day7()
        XCTAssertEqual(126, day.part2(input.lines))
    }
}
