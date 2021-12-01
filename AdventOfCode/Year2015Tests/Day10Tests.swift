import XCTest
import InputReader
import Year2015

class Day10Tests: XCTestCase {

    let day = Day10()
    
    func test_part1() {
        XCTAssertEqual(492982, day.part1([1,3,2,1,1,3,1,1,1,2]))
    }
    
    func test_part2() {
        XCTAssertEqual(6989950, day.part2([1,3,2,1,1,3,1,1,1,2]))
    }
    
    func test_examples() {
        XCTAssertEqual([1,1], day.process([1]))
        XCTAssertEqual([2,1], day.process([1,1]))
        XCTAssertEqual([1,2,1,1], day.process([2,1]))
        XCTAssertEqual([1,1,1,2,2,1], day.process([1,2,1,1]))
        XCTAssertEqual([3,1,2,2,1,1], day.process([1,1,1,2,2,1]))
    }
}
