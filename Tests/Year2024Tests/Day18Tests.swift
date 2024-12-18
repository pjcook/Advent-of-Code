import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", Bundle.module).lines
    let day = Day18()

    func test_part1() {
//        measure {
        XCTAssertEqual(280, day.part1(Array(input.prefix(1024)), size: 71))
//        }
    }
    
    func test_part1_example() {
        let input = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
""".lines
        XCTAssertEqual(22, day.part1(Array(input.prefix(12)), size: 7))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("28,56", day.part2(input, size: 71))
//        }
    }
    
    func test_part2_example() {
        let input = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
""".lines
        XCTAssertEqual("6,1", day.part2(input, size: 7))
    }
}
