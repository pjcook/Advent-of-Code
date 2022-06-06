import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day14Tests: XCTestCase {    
    func test_part1() {
        let day = Day14()
        XCTAssertEqual(1413131339, day.part1(37, iterations: 540561))
    }
    
    func test_part2() {
        let day = Day14()
        XCTAssertEqual(20254833, day.part2(37, iterations: 540561))
    }
    
    func test_part1_example1() {
        let day = Day14()
        XCTAssertEqual(5158916779, day.part1(37, iterations: 9))
    }
    
    func test_part1_example2() {
        let day = Day14()
        XCTAssertEqual(5941429882, day.part1(37, iterations: 2018))
    }
    
    func test_part1_example3() {
        let day = Day14()
        XCTAssertEqual(9251071085, day.part1(37, iterations: 18))
    }
    
    func test_part2_example1() {
        let day = Day14()
        XCTAssertEqual(9, day.part2(37, iterations: 51589))
    }
}
