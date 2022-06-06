import XCTest
import InputReader
import Year2021

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Year2021.bundle).integers
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(1121, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1065, day.part2(input))
//        }
    }
}
