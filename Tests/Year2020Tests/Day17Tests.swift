import XCTest
import InputReader
import Year2020

class Day17Tests: XCTestCase {
    let input = Input("Day17.input", .module).lines
    let day = Day17()

    func test_part1() {
        XCTAssertEqual(291, day.part1(input))
    }
    
    func test_part2() {
        let day = Day17Part2()
        XCTAssertEqual(1524, day.part2(input))
    }
    
    func test_part1_example() {
        let input = """
        .#.
        ..#
        ###
        """.lines
        XCTAssertEqual(112, day.part1(input))
    }
    
    func test() {
        let input = """
        .#.
        ..#
        ###
        """.lines
        let data = day.parse(input)
        day.draw(data, length: 3, cycle: 1)
        let data2 = day.padData(data)
        day.draw(data2, length: 5, cycle: 1)
    }
}
