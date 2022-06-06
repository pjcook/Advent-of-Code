import XCTest
import InputReader
import Year2015

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Year2015.bundle).lines[0]
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(138, day.part1(input))
//        }
    }
    
    func test_part1b() {
//        measure {
        XCTAssertEqual(138, day.part1b(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1771, day.part2(input))
//        }
    }
    
    func test_part2b() {
//        measure {
        XCTAssertEqual(1771, day.part2(input))
//        }
    }
}
