import XCTest
import InputReader
import Year2025

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).lines
    let input2 = Input("Day9_full.input", Bundle.module).lines
    let day = Day9()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(4745816424, day.part1(input2))
//                }
    }

    func test_part1_example() throws {
        let input = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
""".lines
        XCTAssertEqual(50, day.part1(input))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(1351617690, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
""".lines
        XCTAssertEqual(24, day.part2(input))
    }
}
