import XCTest
import InputReader
import Year2024

class Day22Tests: XCTestCase {
    
    let input = Input("Day22.input", Bundle.module).lines
    let day = Day22()

    func test_part1() {
//        measure {
        XCTAssertEqual(485, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
""".lines
        XCTAssertEqual(5, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(74594, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
""".lines
        XCTAssertEqual(7, day.part2(input))
    }
}
