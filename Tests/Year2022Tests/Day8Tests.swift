import XCTest
import InputReader
import StandardLibraries
import Year2022

class Day8Tests: XCTestCase {
    
    let grid = Grid(Input("Day8.input", Bundle.module).lines)
    let day = Day8()

    func test_part1() {
//        measure {
        XCTAssertEqual(1835, day.part1(grid))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(263670, day.part2(grid))
//        }
    }
}

extension Day8Tests {
    func test_part1_example() throws {
        let input = Grid("""
30373
25512
65332
33549
35390
""".lines)
        XCTAssertEqual(21, day.part1(input))
    }
    
    func test_part2_example() throws {
        let input = Grid("""
30373
25512
65332
33549
35390
""".lines)
        XCTAssertEqual(8, day.part2(input))
    }
}
