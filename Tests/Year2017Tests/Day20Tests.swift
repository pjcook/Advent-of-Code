import XCTest
import InputReader
import Year2017

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).lines
    let day = Day20()

    func test_part20() {
//        measure {
        XCTAssertEqual(157, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        // high 580
        XCTAssertEqual(499, day.part2(input))
//        }
    }
}
