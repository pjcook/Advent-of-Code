import XCTest
import InputReader
import Year2021

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Year2021.bundle).lines
    let day = Day3()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
