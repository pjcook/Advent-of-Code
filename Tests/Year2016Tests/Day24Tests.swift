import XCTest
import InputReader
import Year2016

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(448, day.part1(input, shouldReturn: false))
//        }
    }
    
    func test_part1_example() {
        let input = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
""".lines
        XCTAssertEqual(14, day.part1(input, shouldReturn: false))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(672, day.part1(input, shouldReturn: true))
//        }
    }
}
