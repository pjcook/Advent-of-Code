import XCTest
import InputReader
import Year2016

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Bundle.module).lines
    let day = Day8()

    func test_part1() {
//        measure {
        XCTAssertEqual(119, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        // It prints out `ZFHFSFOGPO`
        XCTAssertEqual(119, day.part2(input))
//        }
    }
}
