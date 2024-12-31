import XCTest
import InputReader
import Year2016

class Day16Tests: XCTestCase {
    
    let day = Day16()

    func test_part1() {
//        measure {
        XCTAssertEqual("11111000111110000", day.part1("01111001100111011", length: 272))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual("01100", day.part1("10000", length: 20))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("10111100110110100", day.part1("01111001100111011", length: 35651584))
//        }
    }
}
