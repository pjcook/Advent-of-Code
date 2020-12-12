import XCTest
import InputReader
@testable import Year2020

class Day25Tests: XCTestCase {
    let input = Input("Day25.input", Year2020.bundle).lines
    let day = Day25()

    func test_part1() {
        XCTAssertEqual(0, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
}
