import XCTest
import InputReader
import Year2015

class Day4Tests: XCTestCase {
    
    let input = "iwrupvqb"
    let day = Day4()

    func test_part1() {
//        measure {
        XCTAssertEqual(346386, day.part1(input))
//        }
    }
    
//    func test_part1_examples() {
//        XCTAssertEqual(609043, day.part1("abcdef"))
//    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(9958218, day.part1(input, prefix: "000000"))
//        }
    }
}
