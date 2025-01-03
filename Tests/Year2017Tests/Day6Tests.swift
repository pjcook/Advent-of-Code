import XCTest
import InputReader
import Year2017

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).input.components(separatedBy: "    ").compactMap(Int.init)
    let day = Day6()

    func test_part6() {
//        measure {
        XCTAssertEqual(11137, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(5, day.part1([0,2,7,0]))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1037, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(4, day.part2([0,2,7,0]))
    }
}
