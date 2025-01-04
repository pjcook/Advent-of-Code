import XCTest
import InputReader
import Year2017

class Day17Tests: XCTestCase {
    
    let day = Day17()

    func test_part1() {
//        measure {
        XCTAssertEqual(596, day.part1(377))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(638, day.part1(3))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(39051595, day.part2(377))
//        }
    }
}
