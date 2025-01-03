import XCTest
import InputReader
import Year2017

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).integers
    let day = Day5()

    func test_part1() {
//        measure {
        XCTAssertEqual(336905, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
0
3
0
1
-3
""".integers
        XCTAssertEqual(5, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(21985262, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
0
3
0
1
-3
""".integers
        XCTAssertEqual(10, day.part2(input))
    }
}
