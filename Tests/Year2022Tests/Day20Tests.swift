import XCTest
import InputReader
import Year2022

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).integers
    let day = Day20()

    func test_part20() {
//        measure {
        XCTAssertEqual(4578, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2159638736133, day.part2(input))
//        }
    }
}

extension Day20Tests {
    func test_part1_example() {
        let input = """
1
2
-3
3
-2
0
4
""".integers
        XCTAssertEqual(3, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
1
2
-3
3
-2
0
4
""".integers
        XCTAssertEqual(1623178306, day.part2(input))
    }
}
