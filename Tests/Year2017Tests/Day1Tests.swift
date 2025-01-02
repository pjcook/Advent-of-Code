import XCTest
import InputReader
import Year2017

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).input.map({ Int(String($0))! })
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(1177, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1060, day.part2(input))
//        }
    }
}
