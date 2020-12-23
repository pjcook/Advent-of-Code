import XCTest
import InputReader
import Year2020

class Day23Tests: XCTestCase {
    let input = [1,5,7,6,2,3,9,8,4]
    let day = Day23()

    func test_part1() {
        XCTAssertEqual(58427369, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_part1_example() {
        XCTAssertEqual(92658374, day.part1([3,8,9,1,2,5,4,6,7], turns: 10))
        XCTAssertEqual(67384529, day.part1([3,8,9,1,2,5,4,6,7], turns: 100))
    }
    
    func test_part2_example() {
        XCTAssertEqual(149245887792, day.part2([3,8,9,1,2,5,4,6,7]))
    }
    
    func test_pick() {
        XCTAssertEqual(5, day.findIndex(start: 5, increment: 5, valueCount: input.count))
    }
}
