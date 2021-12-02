import XCTest
import InputReader
import Year2021

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Year2021.bundle).lines
    let day = Day2()

    func test_part1() {
        measure {
        XCTAssertEqual(1480518, day.part1(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(1282809906, day.part2(input))
        }
    }
    
    func test_part1b() {
        measure {
        XCTAssertEqual(1480518, day.part1b(input))
        }
    }
    
    func test_part2b() {
        measure {
        XCTAssertEqual(1282809906, day.part2b(input))
        }
    }
    
    func test_parsing() {
        XCTAssertEqual(1000, day.parse(input).count)
    }
}
