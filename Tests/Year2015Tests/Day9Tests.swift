import XCTest
import InputReader
import Year2015

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", .module).lines
    let day = Day9()

    func test_part1() throws {
        // 358 too high
        // 240 too high
        let shortestDistane = try day.part1(input)
        XCTAssertNotEqual(-1, shortestDistane)
        XCTAssertEqual(207, shortestDistane)
    }
    
    func test_part2() throws {
        let longestRoute = try day.part2(input)
        XCTAssertNotEqual(-1, longestRoute)
        XCTAssertEqual(804, longestRoute)
    }
}
