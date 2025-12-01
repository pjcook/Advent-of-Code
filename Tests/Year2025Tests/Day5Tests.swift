import XCTest
import InputReader
import StandardLibraries
import Year2025

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).lines
    let day = Day5()

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
