import XCTest
import InputReader
import Year2016

class Day19Tests: XCTestCase {
    
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual(1830117, day.part1(3012210))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(3, day.part1(5))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1417887, day.part2(3012210))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(2, day.part2(5))
    }
}
