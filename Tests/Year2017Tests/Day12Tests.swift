import XCTest
import InputReader
import Year2017

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(113, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
""".lines
        XCTAssertEqual(6, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(202, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
""".lines
        XCTAssertEqual(2, day.part2(input))
    }
}
