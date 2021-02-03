import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day25Tests: XCTestCase {
    let input = Input("Day25.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day25()
        XCTAssertEqual(0, day.part1(input))
    }
}
