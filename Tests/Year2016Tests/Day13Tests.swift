import XCTest
import InputReader
import StandardLibraries
import Year2016

class Day13Tests: XCTestCase {
    
    let day = Day13()

    func test_part1() {
//        measure {
        XCTAssertEqual(82, day.part1(1362, size: Point(50,50), destination: Point(31,39)))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(11, day.part1(10, size: Point(10,10), destination: Point(7,4)))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(138, day.part2(1362, size: Point(30,30)))
//        }
    }
}
