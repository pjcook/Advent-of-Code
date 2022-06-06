import XCTest
import InputReader
import Year2015

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Year2015.bundle).lines[0]
    let day = Day3()

    func test_part1() {
//        measure {
        XCTAssertEqual(2565, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2639, day.part2(input))
//        }
    }
}
