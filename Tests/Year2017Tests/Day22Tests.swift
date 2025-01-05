import XCTest
import InputReader
import Year2017

class Day22Tests: XCTestCase {
    
    let input = Input("Day22.input", Bundle.module).lines
    let day = Day22()

    func test_part1() {
//        measure {
        XCTAssertEqual(5256, day.part1(input, bursts: 10000))
//        }
    }
    
    func test_part1_example() {
        let input = """
..#
#..
...
""".lines
        XCTAssertEqual(41, day.part1(input, bursts: 70))
        XCTAssertEqual(5587, day.part1(input, bursts: 10000))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2511345, day.part2(input, bursts: 10000000))
//        }
    }
    
    func test_part2_example() {
        let input = """
..#
#..
...
""".lines
        XCTAssertEqual(2511944, day.part2(input, bursts: 10000000))
    }
}
