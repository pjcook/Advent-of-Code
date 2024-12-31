import XCTest
import InputReader
import Year2016

class Day14Tests: XCTestCase {
    
    let day = Day14()

    func test_part1() {
//        measure {
        XCTAssertEqual(15035, day.part1("ihaygndm"))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(22728, day.part1("abc"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(19968, day.part2("ihaygndm"))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(22551, day.part2("abc"))
    }
}
