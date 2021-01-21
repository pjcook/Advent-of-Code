import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day20Tests: XCTestCase {
    let input = Input("Day20.input", Year2018.bundle).input

    func test_part1() {
        let day = Day20()
        XCTAssertEqual(4121, day.part1(input))
    }
    
    func test_part2() {
        let day = Day20()
        XCTAssertEqual(8636, day.part2(input))
    }
    
    func test_part1_example1() {
        let day = Day20()
        let input = "^ENWWW(NEEE|SSE(EE|N))$"
        XCTAssertEqual(10, day.part1(input))
    }
    
    func test_part2_example1() {
        let day = Day20()
        let input = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
        XCTAssertEqual(18, day.part1(input))
    }
}
