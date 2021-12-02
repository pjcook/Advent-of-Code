import XCTest
import InputReader
import Year2021

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", Year2021.bundle).lines
    let day = Day14()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
