import XCTest
import InputReader
import Year2024

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).lines
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(2264607, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
3   4
4   3
2   5
1   3
3   9
3   3
""".lines
        XCTAssertEqual(11, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(19457120, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
3   4
4   3
2   5
1   3
3   9
3   3
""".lines
        XCTAssertEqual(31, day.part2(input))
    }
}
