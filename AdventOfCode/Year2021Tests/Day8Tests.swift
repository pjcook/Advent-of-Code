import XCTest
import InputReader
import Year2021

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Year2021.bundle).lines
    let day = Day8()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
