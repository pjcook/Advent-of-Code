import XCTest
import InputReader
import Year2021

class Day24Tests: XCTestCase {
    
    let day = Day24()

    func test_part1() {
        XCTAssertEqual(0, day.validate([9,6,9,1,8,9,9,6,9,2,4,9,9,1]))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.validate([9,1,8,1,1,2,4,1,9,1,1,6,4,1]))
    }
    
}
