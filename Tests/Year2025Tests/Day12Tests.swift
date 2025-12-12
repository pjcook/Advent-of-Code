import XCTest
import InputReader
import StandardLibraries
import Year2025

class Day12Tests: XCTestCase {

    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() throws {
        //        measure {
        let result = day.part1(input)
        XCTAssertEqual(485, result)
        //        }
    }
}
