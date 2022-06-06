import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day19Tests: XCTestCase {
    let input = Input("Day19.input", Year2018.bundle).lines

    func test_part1() {
        let day = Day19()
        XCTAssertEqual(2016, day.solve(input))
    }
    
    func test_part2() {
        let day = Day19()
        XCTAssertEqual(22674960, day.part2(input))
    }
    
    func test_part1_example1() {
        let day = Day19()
        let input = Input("Day19_example1.input", Year2018.bundle).lines
        XCTAssertEqual(6, day.solve(input))
    }
}
