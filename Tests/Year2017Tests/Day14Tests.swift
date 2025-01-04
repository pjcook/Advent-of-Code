import XCTest
import InputReader
import Year2017

class Day14Tests: XCTestCase {
    
    let day = Day14()

    func test_part1() {
//        measure {
        XCTAssertEqual(8194, day.part1("uugsqrei"))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(8108, day.part1("flqrgnkx"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1141, day.part2("uugsqrei"))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(1242, day.part2("flqrgnkx"))
    }
}
