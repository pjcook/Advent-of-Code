import XCTest
import InputReader
import Year2017

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).input
    let day = Day11()

    func test_part1() {
//        measure {
        XCTAssertEqual(808, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(3, day.part1("ne,ne,ne"))
        XCTAssertEqual(0, day.part1("ne,ne,sw,sw"))
        XCTAssertEqual(2, day.part1("ne,ne,s,s"))
        XCTAssertEqual(3, day.part1("se,sw,se,sw,sw"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1556, day.part2(input))
//        }
    }
}
