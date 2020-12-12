import XCTest
import InputReader
import Year2020

class Day15Tests: XCTestCase {
    let input = Input("Day15.input", Year2020.bundle).lines
    let day = Day15()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
