import XCTest
import InputReader
import Year2022

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Bundle.module).integers
    let day = Day21()

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
