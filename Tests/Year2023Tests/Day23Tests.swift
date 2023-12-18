import XCTest
import InputReader
import Year2023

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Bundle.module).lines
    let day = Day23()

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
