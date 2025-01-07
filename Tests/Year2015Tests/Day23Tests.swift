import XCTest
import InputReader
import Year2015

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", .module).lines
    let day = Day23()

    func test_part1() {
        XCTAssertEqual(170, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(247, day.part2(input))
    }
}
