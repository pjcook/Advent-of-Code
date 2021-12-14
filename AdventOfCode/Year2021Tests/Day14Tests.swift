import XCTest
import InputReader
import Year2021

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", Year2021.bundle).lines
    let day = Day14()

    func test_part1() {
        XCTAssertEqual(2233, day.part1(input, steps: 10))
    }
    
    func test_part2() {
        // 2884513602165 too high
        // 2884513602165
        XCTAssertEqual(2884513602165, day.part2(input, steps: 40))
    }
    
    func test_parsing() {
        let (template, pairs) = day.parse(input)
        XCTAssertEqual(20, template.count)
        XCTAssertEqual(100, pairs.count)
    }

    func test_example() {
        let input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
""".lines
        XCTAssertEqual(1588, day.part2(input, steps: 10))
        XCTAssertEqual(2188189693529, day.part2(input, steps: 40))
    }
}
