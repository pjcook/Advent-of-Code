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
            XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1))
        }
    }
    
    func test_part2() throws {
        measure {
            XCTAssertEqual(3219, Day6.count(input: input, reduce: Day6.reduce_part2))
        }
    }
    
    func test_part1_v2() throws {
        measure {
            XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1_v2))
        }
    }
    
    func test_part2_v2() throws {
        measure {
            XCTAssertEqual(3219, Day6.count(input: input, reduce: Day6.reduce_part2_v2))
        }
    }
    
    func test_part1_v3() throws {
        measure {
            XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1_v3))
        }
    }
    
    func test_part1_daniel() {
        measure {
            XCTAssertEqual(6596, Day6.part1_daniel(input: input))
        }
    }
    
    func test_part2_daniel() {
        measure {
            XCTAssertEqual(3219, Day6.part2_daniel(input: input))
        }
    }
}
