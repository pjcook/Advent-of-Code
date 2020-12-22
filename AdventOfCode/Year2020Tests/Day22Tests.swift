import XCTest
import InputReader
import Year2020

class Day22Tests: XCTestCase {
    let input = Input("Day22.input", Year2020.bundle).lines
    let day = Day22()

    func test_part1() {
        measure {
        XCTAssertEqual(32495, day.part1(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(32665, day.part2(input))
        }
    }
    
    func test_part1_example() {
        let input = """
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
        """.lines
        XCTAssertEqual(306, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
        """.lines
        XCTAssertEqual(291, day.part2(input))
    }
}
