import XCTest
import InputReader
@testable import Year2020

class Day7Tests: XCTestCase {
    let input = try Input("Day7.input", Year2020.bundle)
    
    func test_part1() {
        let day = Day7()
        XCTAssertEqual(486, day.part1(input))
    }
    
    func test_part2() {
        let day = Day7()
        XCTAssertEqual(69285, day.part2(input))
    }
}
