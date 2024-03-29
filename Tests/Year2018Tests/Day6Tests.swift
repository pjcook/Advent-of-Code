import XCTest
import InputReader
import Year2018

class Day6Tests: XCTestCase {
    let input = Input("Day6.input", .module)
    
    func test_part1() {
        let day = Day6()
        XCTAssertEqual(4771, day.part1(input.lines))
    }
    
    func test_part2() {
        let day = Day6()
        XCTAssertEqual(39149, day.part2(input.lines))
    }
    
    func test_part1_example() {
        let day = Day6()
        let input = """
        1, 1
        1, 6
        8, 3
        3, 4
        5, 5
        8, 9
        """
        XCTAssertEqual(17, day.part1(input.lines))
    }
}
