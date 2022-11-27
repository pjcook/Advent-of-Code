import XCTest
import InputReader
import Year2015

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", .module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual(1598415, day.part1(input))
//        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(3812909, day.part2(input))
        }
    }
    
    func test_part2_examples() {
        XCTAssertEqual(34, day.part2(["2x3x4"]))
        XCTAssertEqual(14, day.part2(["1x1x10"]))
    }
}
