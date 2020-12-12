import XCTest
import InputReader
@testable import Year2020

class Day19Tests: XCTestCase {
    let input = Input("Day19.input", Year2020.bundle).lines
    let day = Day19()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
