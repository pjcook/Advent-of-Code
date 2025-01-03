import XCTest
import InputReader
import Year2017

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).input
    let day = Day9()

    func test_part1() {
//        measure {
        XCTAssertEqual(9662, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(1, day.part1("{}"))
        XCTAssertEqual(6, day.part1("{{{}}}"))
        XCTAssertEqual(5, day.part1("{{},{}}"))
        XCTAssertEqual(16, day.part1("{{{},{},{{}}}}"))
        XCTAssertEqual(1, day.part1("{<a>,<a>,<a>,<a>}"))
        XCTAssertEqual(9, day.part1("{{<ab>},{<ab>},{<ab>},{<ab>}}"))
        XCTAssertEqual(9, day.part1("{{<!!>},{<!!>},{<!!>},{<!!>}}"))
        XCTAssertEqual(3, day.part1("{{<a!>},{<a!>},{<a!>},{<ab>}}"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(4903, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(0, day.part2("<>"))
        XCTAssertEqual(17, day.part2("<random characters>"))
        XCTAssertEqual(3, day.part2("<<<<>"))
        XCTAssertEqual(2, day.part2("<{!>}>"))
        XCTAssertEqual(0, day.part2("<!!>"))
        XCTAssertEqual(0, day.part2("<!!!>>"))
        XCTAssertEqual(10, day.part2("<{o\"i!a,<{i<a>"))
    }
}
