import XCTest
import InputReader
import Year2020

class Day13Tests: XCTestCase {
    let input = Input("Day13.input", .module).lines
    let day = Day13()

    func test_part1() {
        XCTAssertEqual(2995, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(1012171816131114, day.part2(input))
    }
    
    func test_part2_example() {
        let input = """
        939
        7,13,x,x,59,x,31,19
        """.lines
        XCTAssertEqual(1068781, day.part2(input))
    }
}
