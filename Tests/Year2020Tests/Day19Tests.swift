import XCTest
import InputReader
import Year2020

class Day19Tests: XCTestCase {
    let input = Input("Day19.input", .module).lines
    let day = Day19()

    func test_part1() {
        let parsed = try! day.parse(input)
        XCTAssertEqual(134, day.part1(rules: parsed.0, messages: parsed.1))
    }
    
    func test_part2() {
        let parsed = try! day.parse(input)
        XCTAssertEqual(377, day.part2(rules: parsed.0, messages: parsed.1))
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
    
    func test_part2_example() throws {
        let input = """
        42: 9 14 | 10 1
        9: 14 27 | 1 26
        10: 23 14 | 28 1
        1: "a"
        11: 42 31
        5: 1 14 | 15 1
        19: 14 1 | 14 14
        12: 24 14 | 19 1
        16: 15 1 | 14 14
        31: 14 17 | 1 13
        6: 14 14 | 1 14
        2: 1 24 | 14 4
        0: 8 11
        13: 14 3 | 1 12
        15: 1 | 14
        17: 14 2 | 1 7
        23: 25 1 | 22 14
        28: 16 1
        4: 1 1
        20: 14 14 | 1 15
        3: 5 14 | 16 1
        27: 1 6 | 14 18
        14: "b"
        21: 14 1 | 1 14
        25: 1 1 | 1 14
        22: 14 14
        8: 42
        26: 14 22 | 1 20
        18: 15 15
        7: 14 5 | 1 21
        24: 14 1

        bbabbbbaabaabba
        babbbbaabbbbbabbbbbbaabaaabaaa
        aaabbbbbbaaaabaababaabababbabaaabbababababaaa
        bbbbbbbaaaabbbbaaabbabaaa
        bbbababbbbaaaaaaaabbababaaababaabab
        ababaaaaaabaaab
        ababaaaaabbbaba
        baabbaaaabbaaaababbaababb
        abbbbabbbbaaaababbbbbbaaaababb
        aaaaabbaabaaaaababaa
        aaaabbaaaabbaaa
        aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
        babaaabbbaaabaababbaabababaaab
        aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
        abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
        """.lines
        let parsed = try day.parse(input)
        XCTAssertEqual(12, day.part2(rules: parsed.0, messages: parsed.1))
    }
        
    func test_parsing() throws {
        let results = try day.parse(input)
        XCTAssertEqual(135, results.0.count)
        XCTAssertEqual(437, results.1.count)
        XCTAssertEqual("babaaaabbbaaaabbbaaaaaba", results.1.first)
        XCTAssertEqual("bbabbbbbbaabbbbaabbbbabbabaaaababaabbbbb", results.1.last)
    }
    
    func test_substring() {
        let pattern = "bbabbbbbbaaxbbbaabbbbabbabayaababaabbbbb"
        let indexX = pattern.firstIndex(of: "x")!
        let prefix = pattern.prefix(upTo: indexX)
        XCTAssertEqual("bbabbbbbbaa", prefix)
        let indexY = pattern.firstIndex(of: "y")!
        let suffix = pattern.suffix(from: pattern.index(indexY, offsetBy: 1))
        XCTAssertEqual("aababaabbbbb", suffix)
        let substring = pattern[pattern.index(indexX, offsetBy: 1)..<indexY]
        XCTAssertEqual("bbbaabbbbabbaba", substring)
    }
}
