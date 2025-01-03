import XCTest
import InputReader
import Year2017

class Day4Tests: XCTestCase {
    
    let input = Input("Day4.input", Bundle.module).lines
    let day = Day4()

    func test_part4() {
//        measure {
        XCTAssertEqual(477, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(167, day.part2(input))
//        }
    }
}
