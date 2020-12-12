import XCTest
import InputReader
@testable import Year2020

class Day12Tests: XCTestCase {
    let input = Input("Day12.input", Year2020.bundle).lines
    
    func test_part1() {
        let day = Day12()
        XCTAssertEqual(1319, day.part1(input))
    }
    
    func test_part2() {
        let day = Day12()
        XCTAssertEqual(62434, day.part2(input))
    }
    
    func test_part1_example() {
        let input = """
        F10
        N3
        F7
        R90
        F11
        """.lines
        let day = Day12()
        XCTAssertEqual(25, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
        F10
        N3
        F7
        R90
        F11
        """.lines
        let day = Day12()
        XCTAssertEqual(286, day.part2(input))
    }
}
