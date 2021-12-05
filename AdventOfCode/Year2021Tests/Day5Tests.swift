import XCTest
import InputReader
import Year2021

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Year2021.bundle).lines
    let day = Day5()

    func test_part1() {
//        measure {
        XCTAssertEqual(4826, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(16793, day.part1(input, includeDiagonals: true))
//        }
    }
    
    func test_parsing() {
        let data = day.parse(input)
        XCTAssertEqual(500, data.count)
    }
    
    func test_example() {
        let input = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
""".lines
        XCTAssertEqual(5, day.part1(input))
    }
    
    func test_example2() {
        let input = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
""".lines
        XCTAssertEqual(12, day.part1(input, includeDiagonals: true))
    }
}
