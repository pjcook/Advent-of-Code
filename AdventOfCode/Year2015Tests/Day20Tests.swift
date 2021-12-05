import XCTest
import InputReader
import Year2015

class Day20Tests: XCTestCase {
    
    let day = Day20()

    func test_part1() {
        // too high 1854765
        // too high 1049160
        XCTAssertEqual(1049160, day.part1(36000000))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(36000000))
    }
    
    func test_example() {
        XCTAssertEqual(8, day.part1(150))
    }
}
