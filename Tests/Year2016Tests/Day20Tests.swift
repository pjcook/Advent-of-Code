import XCTest
import InputReader
import Year2016

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).integers
    let day = Day1()

    func test_part20() {
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
