import XCTest
import InputReader
import Year2017

class Day15Tests: XCTestCase {
    
    let day = Day15()

    func test_part1() {
//        measure {
        XCTAssertEqual(609, day.part1(a: 883, b: 879))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(588, day.part1(a: 65, b: 8921))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(253, day.part2(a: 883, b: 879))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(309, day.part2(a: 65, b: 8921))
    }
}
