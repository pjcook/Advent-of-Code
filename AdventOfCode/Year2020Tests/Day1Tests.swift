import XCTest
import InputReader
@testable import Year2020

class Day1Tests: XCTestCase {

    func test_part1() throws {
        guard let input = try readInput(filename: "Day1.input", delimiter: "\n", cast: Int.init, bundle: Year2020.bundle) as? [Int] else { return XCTFail() }
        XCTAssertEqual(381699, Day1.findMatch(input: input, value: 2020))
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day1.input", delimiter: "\n", cast: Int.init, bundle: Year2020.bundle) as? [Int] else { return XCTFail() }
        XCTAssertEqual(111605670, Day1.findMatch2(input: input, value: 2020))
    }
    
    func test_part1_v2() throws {
        guard let input = try readInput(filename: "Day1.input", delimiter: "\n", cast: Int.init, bundle: Year2020.bundle) as? [Int] else { return XCTFail() }
        let result = Day1.findMatch(input: input, matchValue: 2020, levels: 2, match: +, output: *)
        XCTAssertEqual(381699, result)
    }
    
    func test_part2_v2() throws {
        guard let input = try readInput(filename: "Day1.input", delimiter: "\n", cast: Int.init, bundle: Year2020.bundle) as? [Int] else { return XCTFail() }
        let result = Day1.findMatch(input: input, matchValue: 2020, levels: 3, match: +, output: *)
        XCTAssertEqual(111605670, result)
    }
}
