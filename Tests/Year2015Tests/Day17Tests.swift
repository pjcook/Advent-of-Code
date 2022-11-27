import XCTest
import InputReader
import Year2015

class Day17Tests: XCTestCase {
    
    let input = Input("Day17.input", .module).integers
    let day = Day17()

    func test_part1() {
        XCTAssertEqual(4372, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(4, day.part2(input))
    }
    
    func test_example() {
        let input = [20, 15, 10, 5, 5]
        XCTAssertEqual(4, day.part1(input, litres: 25))
    }
    
    func test_example2() {
        let input = [20, 15, 10, 5, 5]
        XCTAssertEqual(3, day.part2(input, litres: 25))
    }
}
