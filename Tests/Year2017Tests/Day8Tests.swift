import XCTest
import InputReader
import Year2017

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Bundle.module).lines
    let day = Day8()

    func test_part1() {
//        measure {
        XCTAssertEqual(5143, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
""".lines
        XCTAssertEqual(1, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(6209, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
""".lines
        XCTAssertEqual(10, day.part2(input))
    }
}
