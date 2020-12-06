import XCTest
import InputReader
@testable import Year2020

class Day6Tests: XCTestCase {
    var input: [String] = []
        
    override func setUpWithError() throws {
        let input = try Input("Day6.input", Year2020.bundle)
        self.input = input.lines
    }
    
    func test_part1() throws {
        let day = Day6()
        let count = day.count(input: input)
        XCTAssertEqual(6596, count)
    }
    
    func test_part2() throws {
        let day = Day6()
        let count = day.count2(input: input)
        XCTAssertEqual(3219, count)
    }
}
