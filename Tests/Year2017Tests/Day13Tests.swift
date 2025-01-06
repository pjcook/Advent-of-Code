import XCTest
import InputReader
import Year2017

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Bundle.module).lines
    let day = Day13()

    func test_part1() {
//        measure {
        // low  110
        // low  142
        // high 56474
        XCTAssertEqual(1476, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
0: 3
1: 2
4: 4
6: 4
""".lines
        XCTAssertEqual(24, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(3937334, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
0: 3
1: 2
4: 4
6: 4
""".lines
        XCTAssertEqual(10, day.part2(input))
    }
}
