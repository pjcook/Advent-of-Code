import XCTest
import InputReader
import Year2022

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).integers
    let day = Day9()

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
