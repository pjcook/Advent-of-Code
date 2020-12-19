import XCTest
import InputReader
import Year2020

class Day19Tests: XCTestCase {
    let input = Input("Day19.input", Year2020.bundle).lines
    let day = Day19()

    func test_part1() {
        let parsed = try! day.parse(input)
        XCTAssertEqual(134, day.part1(rules: parsed.0, messages: parsed.1))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_part1_example() throws {
        let input = """
        0: 4 1 5
        1: 2 3 | 3 2
        2: 4 4 | 5 5
        3: 4 5 | 5 4
        4: "a"
        5: "b"

        ababbb
        bababa
        abbbab
        aaabbb
        aaaabbb
        """.lines
        let parsed = try day.parse(input)
        XCTAssertEqual(2, day.part1(rules: parsed.0, messages: parsed.1))
    }
        
    func test_parsing() throws {
        let results = try day.parse(input)
        XCTAssertEqual(135, results.0.count)
        XCTAssertEqual(437, results.1.count)
        XCTAssertEqual("babaaaabbbaaaabbbaaaaaba", results.1.first)
        XCTAssertEqual("bbabbbbbbaabbbbaabbbbabbabaaaababaabbbbb", results.1.last)
    }
}
