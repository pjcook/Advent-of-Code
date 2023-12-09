import XCTest
import InputReader
import Year2023

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).lines
    let day = Day9()

    func test_part1() {
        measure {
        XCTAssertEqual(2075724761, day.part1(input))
        }
    }
    
    func test_part1_example1() {
        let input = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".lines
        XCTAssertEqual(114, day.part1(input))
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(1072, day.part2(input))
        }
    }
    
    func test_part2_example1() {
        let input = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".lines
        XCTAssertEqual(2, day.part2(input))
    }
}
