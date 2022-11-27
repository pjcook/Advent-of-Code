import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day12Tests: XCTestCase {
    let input = Input("Day12.input", .module).lines
    
    func test_part1() {
        let day = Day12()
        XCTAssertEqual(2444, day.solve(input, iterations: 20))
    }
    
    func test_part2() {
        let day = Day12()
        XCTAssertEqual(750000000697, day.solve(input, iterations: 50000000000))
    }
    
    func test_part1_example() {
        let day = Day12()
        let input = Input("Day12_example1.input", .module).lines
        XCTAssertEqual(325, day.solve(input, iterations: 20))
    }
}
