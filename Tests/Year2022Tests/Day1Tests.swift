import XCTest
import InputReader
import Year2022

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).integers
    let day = Day1()

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
