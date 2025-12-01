import XCTest
import InputReader
import Year2025
import StandardLibraries

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).lines
    let day = Day11()

    func test_part1() throws {
        //        measure {
        XCTAssertEqual(0, day.part1(input))
        //        }
    }

    func test_part1_example() throws {
        let input = """
0
""".lines
        XCTAssertEqual(0, day.part1(input))
    }

    func test_part2() throws {
        //        measure {
        XCTAssertEqual(0, day.part2(input))
        //        }
    }

    func test_part2_example() throws {
        let input = """
0
""".lines
        XCTAssertEqual(0, day.part2(input))
    }
}
