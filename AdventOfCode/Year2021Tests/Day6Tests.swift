import XCTest
import InputReader
import Year2021

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Year2021.bundle).lines
    let day = Day6()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
