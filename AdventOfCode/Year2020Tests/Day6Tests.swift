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
        measure {
            XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce))
        }
    }
    
    func test_part2() throws {
        measure {
            XCTAssertEqual(3219, Day6.count(input: input, reduce: Day6.reduce2))
        }
    }
}
