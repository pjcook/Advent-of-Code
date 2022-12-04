import XCTest
import InputReader
import Year2022

class Day4Tests: XCTestCase {
    
    let input = Input("Day4.input", Bundle.module).lines
    let day = Day4()

    func test_part1() {
//        measure {
        XCTAssertEqual(424, day.part1(input))
//        }
    }
    
    func test_part1b() {
//        measure {
        XCTAssertEqual(424, day.part1b(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
""".lines
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(804, day.part2(input))
//        }
    }
    
    func test_part2b() {
//        measure {
        XCTAssertEqual(804, day.part2b(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
""".lines
        XCTAssertEqual(4, day.part2(input))
    }
}
