import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day9Tests: XCTestCase {
    func test_part1() {
        measure {
        let day = Day9()
        XCTAssertEqual(398048, day.solve(71307, players: 458))
        }
    }
    
    func test_part2() {
        measure {
        let day = Day9()
        XCTAssertEqual(3180373421, day.solve(7130700, players: 458))
        }
    }
    
    func test_part1_example1() {
        let day = Day9()
        XCTAssertEqual(32, day.solve(25, players: 9))
        XCTAssertEqual(8317, day.solve(1618, players: 10))
        XCTAssertEqual(146373, day.solve(7999, players: 13))
        XCTAssertEqual(2764, day.solve(1104, players: 17))
        XCTAssertEqual(54718, day.solve(6111, players: 21))
        XCTAssertEqual(37305, day.solve(5807, players: 30))
    }
}
