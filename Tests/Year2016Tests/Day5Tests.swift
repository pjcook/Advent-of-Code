import XCTest
import InputReader
import Year2016

class Day5Tests: XCTestCase {
    
//    let input = Input("Day5.input", Bundle.module).integers
    let day = Day5()

    func test_part1() {
//        measure {
        XCTAssertEqual("c6697b55", day.part1("ffykfhsq"))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual("18f47a30", day.part1("abc"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("8c35d1ab", day.part2("ffykfhsq"))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual("05ace8e3", day.part2("abc"))
    }
}
