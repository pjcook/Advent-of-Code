import XCTest
import InputReader
import Year2025

class Day4Tests: XCTestCase {
    
    let input = Input("Day4.input", Bundle.module).lines
    let day = Day4()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(1569, day.part1(input))
//                }
    }

    func test_part1_example() throws {
        let input = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
""".lines
        XCTAssertEqual(13, day.part1(input))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(9280, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
""".lines
        XCTAssertEqual(43, day.part2(input))
    }
}
