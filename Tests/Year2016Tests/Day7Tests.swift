import XCTest
import InputReader
import Year2016

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).integers
    let day = Day7()

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
