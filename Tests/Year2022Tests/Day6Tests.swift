import XCTest
import InputReader
import Year2022

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).input
    let day = Day6()

    func test_part1() {
        measure {
        XCTAssertEqual(1640, day.part1(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(3613, day.part2(input))
        }
    }
}

extension Day6Tests {
    func test_part1_examples() {
//        measure {
        XCTAssertEqual(5, day.part1("bvwbjplbgvbhsrlpgdmjqwftvncz"))
        XCTAssertEqual(6, day.part1("nppdvjthqldpwncqszvftbrmjlhg"))
        XCTAssertEqual(10, day.part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"))
        XCTAssertEqual(11, day.part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"))
//        }
    }
}
