import XCTest
import InputReader
import Year2022

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(449, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(443, day.part2(input))
//        }
    }
}

extension Day12Tests {
    func test_part1_example() {
        let input = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
""".lines
        XCTAssertEqual(31, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
""".lines
        XCTAssertEqual(29, day.part2(input))
    }
}
