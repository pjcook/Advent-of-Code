import XCTest
import InputReader
import Year2025

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).lines
    let day = Day6()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(4722948564882, day.part1(input))
//                }
    }

    func test_part1_example() throws {
        let input = """
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
""".lines
        XCTAssertEqual(4277556, day.part1(input))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(9581313737063, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = """
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
""".lines
        XCTAssertEqual(3263827, day.part2(input))
    }
}
