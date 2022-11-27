import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day23Tests: XCTestCase {
    let input = Input("Day23.input", .module).lines
    
    func test_part1() {
        let day = Day23()
        XCTAssertEqual(408, day.part1(input))
    }
    
    func test_part2() {
        let day = Day23()
        XCTAssertEqual(121167568, day.part2(input))
    }
    
    func test_part2_example() {
        let day = Day23()
        let input = """
        pos=<10,12,12>, r=2
        pos=<12,14,12>, r=2
        pos=<16,12,12>, r=4
        pos=<14,14,14>, r=6
        pos=<50,50,50>, r=200
        pos=<10,10,10>, r=5
        """.lines
        XCTAssertEqual(36, day.part2(input))
    }
}
