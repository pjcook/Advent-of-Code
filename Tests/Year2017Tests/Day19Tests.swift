import XCTest
import InputReader
import Year2017

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Bundle.module).integers
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual(1, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1, day.part2(input))
//        }
    }
}
