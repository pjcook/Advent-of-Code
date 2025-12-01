import XCTest
import InputReader
import Year2025

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

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
