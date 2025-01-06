import XCTest
import InputReader
import StandardLibraries
import Year2017

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(1695, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
""".lines
        XCTAssertEqual(31, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1673, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
""".lines
        XCTAssertEqual(19, day.part2(input))
    }
}
