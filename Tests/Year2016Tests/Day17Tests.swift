import XCTest
import InputReader
import Year2016

class Day17Tests: XCTestCase {
    
    let input = Input("Day17.input", Bundle.module).integers
    let day = Day17()

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
