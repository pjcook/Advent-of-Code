import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day17Tests: XCTestCase {
    let input = Input("Day17.input", .module).lines

    func test_part1() {
        let day = Day17()
        XCTAssertEqual(33052, day.part1(input))
    }
    
    func test_part2() {
        let day = Day17()
        XCTAssertEqual(27068, day.part2(input))
    }
    
    func test_part1_example1() {
        let day = Day17()
        let input = Input("Day17example1.input", .module).lines
        XCTAssertEqual(57, day.part1(input))
    }
    
    func test_part1_example2() {
        let day = Day17()
        let input = Input("Day17example2.input", .module).lines
        XCTAssertEqual(31949, day.part1(input))
    }
    
    func test_parsing() {
        let day = Day17()
        let map = day.parse(input)
        XCTAssertEqual(25414, map.count)
    }
}
