import XCTest
import InputReader
import Year2022

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", Bundle.module).lines
    let day = Day14()

    func test_part1() {
//        measure {
        XCTAssertEqual(578, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(24377, day.part2(input))
//        }
    }
}

extension Day14Tests {
    func test_part1_example() {
        let input = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
""".lines
        XCTAssertEqual(24, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
""".lines
        XCTAssertEqual(93, day.part2(input))
    }
}
