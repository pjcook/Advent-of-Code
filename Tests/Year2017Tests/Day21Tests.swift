import XCTest
import InputReader
import Year2017

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
//        measure {
        XCTAssertEqual(158, day.part1(input, iterations: 5))
//        }
    }
    
    func test_part1_example() {
        let input = """
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
""".lines
        XCTAssertEqual(12, day.part1(input, iterations: 2))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2301762, day.part1(input, iterations: 18))
//        }
    }
}
