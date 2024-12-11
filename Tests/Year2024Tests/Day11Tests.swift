import XCTest
import InputReader
import Year2024
import StandardLibraries

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).input
    let day = Day11()

    func test_part1() {
//        measure {
        XCTAssertEqual(203953, day.solve2(input, iterations: 25))
//        }
    }
    
    func test_part1_example1() {
        let input = "125 17"
        XCTAssertEqual(22, day.solve2(input, iterations: 6))
    }
    
    func test_part1_example2() {
        let input = "125 17"
        XCTAssertEqual(55312, day.solve2(input, iterations: 25))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(242090118578155, day.solve2(input, iterations: 75))
//        }
    }
    
    func test_part2_example() {
        let input = "125 17"
        XCTAssertEqual(65601038650482, day.solve2(input, iterations: 75))
    }
}
