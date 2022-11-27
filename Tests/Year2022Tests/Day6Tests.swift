import XCTest
import InputReader
import Year2022

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).integers
    let day = Day1()

    func test_part6() {
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
