import XCTest
import InputReader
import Year2015

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Year2015.bundle).input
    let day = Day12()

    func test_part1() throws {
        XCTAssertEqual(119433, try day.part1(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual(68466, try day.part2(input))
    }
}
