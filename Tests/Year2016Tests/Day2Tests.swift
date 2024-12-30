import XCTest
import InputReader
import Year2016

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual("69642", day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
ULL
RRDDD
LURDL
UUUUD
""".lines
        
        XCTAssertEqual("1985", day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("8CB23", day.part2(input))
//        }
    }
}
