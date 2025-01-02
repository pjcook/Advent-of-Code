import XCTest
import InputReader
import Year2017

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual(47136, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(250, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
5 9 2 8
9 4 7 3
3 8 6 5
""".lines
        XCTAssertEqual(9, day.part2(input))
    }
}
