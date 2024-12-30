import XCTest
import InputReader
import Year2016

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).input
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(246, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(12, day.part1("R5, L5, R5, R3"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(124, day.part2(input))
//        }
    }
}
