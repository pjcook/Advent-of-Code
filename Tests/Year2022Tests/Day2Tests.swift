import XCTest
import InputReader
import Year2022

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual(13484, day.part1(input))
//        }
    }
    
    func test_part1_test() {
        let input = """
A Y
B X
C Z
""".lines

        XCTAssertEqual(15, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(13433, day.part2(input))
//        }
    }
    
    func test_part2_test() {
        let input = """
A Y
B X
C Z
""".lines

        XCTAssertEqual(12, day.part2(input))
    }
}
