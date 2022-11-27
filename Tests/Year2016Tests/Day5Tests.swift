import XCTest
import InputReader
import Year2016

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).integers
    let day = Day5()

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
