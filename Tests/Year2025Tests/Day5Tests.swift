import XCTest
import InputReader
import StandardLibraries
import Year2025

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).lines
    let day = Day5()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(525, day.part1(input))
//                }
    }

    func test_part1_example() throws {
        let input = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
""".lines
        XCTAssertEqual(3, day.part1(input))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(333892124923577, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
""".lines
        XCTAssertEqual(14, day.part2(input))
    }
}
