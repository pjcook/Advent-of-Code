import XCTest
import InputReader
import Year2020

class Day6Tests: XCTestCase {
    let input = Input("Day6.input", .module).lines
    
    func test_part1() {
        XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1))
    }
    
    func test_part2() {
        XCTAssertEqual(3219, Day6.count(input: input, reduce: Day6.reduce_part2))
    }
    
    func test_part1_v2() {
        XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1_v2))
    }
    
    func test_part2_v2() {
        XCTAssertEqual(3219, Day6.count(input: input, reduce: Day6.reduce_part2_v2))
    }
    
    func test_part1_v3() {
        XCTAssertEqual(6596, Day6.count(input: input, reduce: Day6.reduce_part1_v3))
    }
    
    func test_part1_daniel() {
        XCTAssertEqual(6596, Day6.part1_daniel(input: input))
    }
    
    func test_part2_daniel() {
        XCTAssertEqual(3219, Day6.part2_daniel(input: input))
    }
    
    func test() {
        let result = Set("abcabacad")
        print(result)
    }
}
