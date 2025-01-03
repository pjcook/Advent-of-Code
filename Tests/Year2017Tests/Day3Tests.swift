import XCTest
import InputReader
import Year2017

class Day3Tests: XCTestCase {
    
    let day = Day3()

    func test_part1() {
//        measure {
        XCTAssertEqual(480, day.part1(347991))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(3, day.part1(12))
        XCTAssertEqual(2, day.part1(23))
        XCTAssertEqual(31, day.part1(1024))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(349975, day.part2(347991))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(806, day.part2(747))
    }
}
