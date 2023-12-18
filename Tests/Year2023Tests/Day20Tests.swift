import XCTest
import InputReader
import Year2023

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).lines
    let day = Day20()

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
