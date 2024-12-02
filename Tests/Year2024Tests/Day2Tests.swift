import XCTest
import InputReader
import Year2024

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual(524, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
""".lines
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(569, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
""".lines
        XCTAssertEqual(4, day.part2(input))
    }
    
//    func test_part2_validation() {
//        let input2 = Input("Day2-valid.input", Bundle.module).lines
//        XCTAssertEqual(569, day.part2_validation(input, input2))
//    }
}
