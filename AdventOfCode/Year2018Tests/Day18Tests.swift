import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day18Tests: XCTestCase {
    let input = Input("Day18.input", Year2018.bundle).lines

    func test_part1() {
        let day = Day18()
        XCTAssertEqual(584714, day.part1(input))
    }
    
    func test_part2() {
        let day = Day18()
        XCTAssertEqual(161160, day.part2(input))
    }
}
