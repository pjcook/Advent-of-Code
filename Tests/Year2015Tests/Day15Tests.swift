import XCTest
import InputReader
import Year2015

class Day15Tests: XCTestCase {
    
    let input = Input("Day15.input", .module).lines
    let day = Day15()

    func test_part1() {
        // too low 16676352
        // too low 17401280
        XCTAssertEqual(21367368, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(1766400, day.part2(input))
    }
    
    func test_parsing() {
        let ingredients = day.parse(input)
        XCTAssertEqual(4, ingredients.count)
    }
}
