import XCTest
import InputReader
import Year2016

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).input
    let day = Day9()

    func test_part1() {
//        measure {
        XCTAssertEqual(150914, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(11052855125, day.part2(input))
//        }
    }
}
