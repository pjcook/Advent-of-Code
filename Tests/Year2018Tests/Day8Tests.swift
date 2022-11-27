import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day8Tests: XCTestCase {
    let input = Input("Day8.input", .module).input.split(separator: " ").compactMap({ Int(String($0)) })
    
    func test_part1() {
        let day = Day8()
        let result = day.part1(input)
        XCTAssertEqual(49426, result)
    }
    
    func test_part2() {
        let day = Day8()
        let result = day.part2(input)
        XCTAssertEqual(40688, result)
    }
    
    func test_part1_example() {
        let input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".split(separator: " ").compactMap({ Int(String($0)) })
        let day = Day8()
        let result = day.part1(input)
        XCTAssertEqual(138, result)
    }
    
    func test_part2_example() {
        let input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".split(separator: " ").compactMap({ Int(String($0)) })
        let day = Day8()
        let result = day.part2(input)
        XCTAssertEqual(66, result)
    }
}
