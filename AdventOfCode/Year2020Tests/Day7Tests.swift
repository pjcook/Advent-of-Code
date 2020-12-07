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
    
    func test_parsingToRules() {
        let rules = input.lines.map(Day7.Rule.init)
        XCTAssertEqual(594, rules.count)
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
