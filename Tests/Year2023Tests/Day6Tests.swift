import XCTest
import InputReader
import Year2023

class Day6Tests: XCTestCase {
    
//    let input = Input("Day6.input", Bundle.module).input
    let day = Day6()

    func test_part1() {
        measure {
        XCTAssertEqual(393120, day.part1(time: [62,73,75,65], distance: [644,1023,1240,1023]))
        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(288, day.part1(time: [7,15,30], distance: [9,40,200]))
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(36872656, day.part2(time: 62737565, distance: 644102312401023))
        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(71503, day.part2(time: 71530, distance: 940200))
    }
    
    func test_stuff() {
        XCTAssertEqual(4, day.part2(time: 7, distance: 9))
    }

}
