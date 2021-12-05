import XCTest
import InputReader
import Year2015

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Year2015.bundle).lines
    let day = Day21()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
