import XCTest
import InputReader
import StandardLibraries
import Year2015

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", .module).lines
    let day = Day6()

    func test_part1() throws {
        try XCTAssertEqual(400410, day.part1(input))
    }
    
    func test_part2() throws {
        try XCTAssertEqual(15343601, day.part2(input))
    }
}
