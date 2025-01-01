import XCTest
import InputReader
import Year2016

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Bundle.module).lines
    let day = Day25()

    func test_part1() {
//        measure {
        XCTAssertEqual(182, day.part1(input))
//        }
    }
}
