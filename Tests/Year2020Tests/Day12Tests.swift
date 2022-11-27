import XCTest
import InputReader
import Year2020

class Day12Tests: XCTestCase {
    let input = Input("Day12.input", .module).lines
    let day = Day12()

    func test_part1() {
        XCTAssertEqual(1319, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(62434, day.part2(input))
    }
    
    func test_part1_v2() {
        let day = Day12_v2()
        XCTAssertEqual(1319, day.part1(input))
    }
    
    func test_part2_v2() {
        let day = Day12_v2()
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
        XCTAssertEqual(286, day.part2(input))
    }
}
