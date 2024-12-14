import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", Bundle.module).lines
    let day = Day14()

    func test_part1() {
//        measure {
        // 101 wide 103 tall
        XCTAssertEqual(219150360, day.part1(input, boardSize: Point(101, 103), iterations: 100))
//        }
    }
    
    func test_part1_example() {
        let input = """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
""".lines
        // 11 wide 7 tall, 100 iterations
        XCTAssertEqual(12, day.part1(input, boardSize: Point(11, 7), iterations: 100))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(8053, day.part2(input, boardSize: Point(101, 103)))
//        }
    }
}
