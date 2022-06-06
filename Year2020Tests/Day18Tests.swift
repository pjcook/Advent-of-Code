import XCTest
import InputReader
import Year2020

class Day18Tests: XCTestCase {
    let input = Input("Day18.input", Year2020.bundle).input.replacingOccurrences(of: " ", with: "").lines
    let day = Day18()

    func test_part1() {
        XCTAssertEqual(6640667297513, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(451589894841552, day.part2(input))
    }
    
    func test_part2_example1() {
        XCTAssertEqual(231, day.part2(["1 + 2 * 3 + 4 * 5 + 6"]))
        XCTAssertEqual(51, day.part2(["1 + (2 * 3) + (4 * (5 + 6))"]))
        XCTAssertEqual(1445, day.part2(["5 + (8 * 3 + 9 + 3 * 4 * 3)"]))
        XCTAssertEqual(669060, day.part2(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"]))
        XCTAssertEqual(23340, day.part2(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"]))
        XCTAssertEqual(46, day.part2(["2 * 3 + (4 * 5)"]))
    }
    
    func test_parsing() {
        let input = "(5 * 6 * 5 * 7) + (6 + (8 * 3 * 9 + 2 + 7) + 7 + (4 * 2 + 5)) + 8"
        let calculations = day.parse([input])
        XCTAssertEqual(1, calculations.count)
        XCTAssertEqual(5, calculations[0].elements.count)
    }
}
