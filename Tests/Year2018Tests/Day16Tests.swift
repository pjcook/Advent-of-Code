import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day16Tests: XCTestCase {
    let input = Input("Day16.input", .module).lines

    func test_part1() {
        let day = Day16()
        XCTAssertEqual(521, day.part1(input))
    }
    
    func test_part2() {
        let day = Day16()
        XCTAssertEqual(594, day.part2(input))
    }
    
    func test_parsing() {
        let day = Day16()
        let (manual, instructions) = day.parse(input)
        XCTAssertEqual(761, manual.samples.count)
        XCTAssertEqual(968, instructions.count)
    }
}
