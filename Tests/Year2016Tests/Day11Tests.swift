import XCTest
import InputReader
import Year2016

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).integers
    let day = Day11()

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
