import XCTest
import InputReader
import Year2015

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", .module).integers
    let day = Day24()

    func test_part1() {
        XCTAssertEqual(10723906903, day.part1(input))
    }
    
    func test_part2() {
        // high 139699414
        XCTAssertEqual(74850409, day.part2(input))
    }
}
