import XCTest
import InputReader
import Year2016

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).integers
    let day = Day12()

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
