import XCTest
import InputReader
import Year2017

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Bundle.module).integers
    let day = Day3()

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
