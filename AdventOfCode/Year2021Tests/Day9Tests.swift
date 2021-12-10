import XCTest
import InputReader
import Year2021

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Year2021.bundle).lines
    let day = Day9()

    func test_part1() {
//        measure {
        XCTAssertEqual(496, day.part1(input))
//        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(902880, day.part2(input))
        }
    }
    
    func test_parsing() {
//        measure {
        let grid = day.parse(input)
        XCTAssertEqual(10000, grid.items.count)
        XCTAssertEqual(100, grid.columns)
        XCTAssertEqual(100, grid.rows)
//        }
    }
    
    func test_example2() {
        let input = """
2199943210
3987894921
9856789892
8767896789
9899965678
""".lines
        XCTAssertEqual(15, day.part1(input))
        XCTAssertEqual(1134, day.part2(input))
    }
}
