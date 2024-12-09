import XCTest
import InputReader
import Year2024

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).input
    let day = Day9()

    func test_part1() {
//        measure {
        XCTAssertEqual(6283404590840, day.part1(input))
//        }
    }
    
    func test_part1_example1() {
        let input = "2333133121414131402"
        XCTAssertEqual(1928, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(6304576012713, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = "2333133121414131402"
        XCTAssertEqual(2858, day.part2(input))
    }
}
