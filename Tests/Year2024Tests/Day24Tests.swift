import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(25810, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
""".lines
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(652666650475950, day.part2(input))
//        }
    }
}
