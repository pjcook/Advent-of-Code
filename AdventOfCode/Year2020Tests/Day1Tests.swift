import XCTest
import InputReader
@testable import Year2020

class Day1Tests: XCTestCase {
    
    var input: [Int] = []
    
    override func setUpWithError() throws {
        let input = try Input("Day1.input", Year2020.bundle)
        self.input = input.lines.compactMap(Int.init)
    }

    func test_part1() {
        XCTAssertEqual(381699, Day1.findMatch(input: input, value: 2020))
    }
    
    func test_part2() {
        XCTAssertEqual(111605670, Day1.findMatch2(input: input, value: 2020))
    }
    
    func test_part1_v2() {
        XCTAssertEqual(381699, Day1.findMatch(input: input, matchValue: 2020, levels: 2, match: +, output: *))
    }
    
    func test_part2_v2() {
        XCTAssertEqual(111605670, Day1.findMatch(input: input, matchValue: 2020, levels: 3, match: +, output: *))
    }
    
    func test_part1_v3() {
        XCTAssertEqual(381699, Day1.findMatch3(input: input, value: 2020))
    }
    
    func test() throws {
        let match = 2020
        let values = Set(input)
        var result = 0
        var iterator = values.makeIterator()
        var value = iterator.next()
        while value != nil {
            if values.contains(match - value!) {
                result = value! * (match - value!)
                break
            }
            value = iterator.next()
        }
        XCTAssertEqual(381699, result)
    }
}
