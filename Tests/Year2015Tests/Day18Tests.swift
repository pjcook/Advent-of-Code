import XCTest
import InputReader
import Year2015

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", .module).lines
    let day = Day18()

    func test_part1() {
        XCTAssertEqual(768, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(781, day.part2(input))
    }
    
    func test_parsing() {
        let grid = day.parse(input)
        XCTAssertEqual(10000, grid.items.count)
        XCTAssertEqual(100, grid.columns)
    }
    
    func test_example() {
        let input = """
.#.#.#
...##.
#....#
..#...
#.#..#
####..
""".lines
        XCTAssertEqual(4, day.part1(input, steps: 4))
    }
    
    func test_example2() {
        let input = """
.#.#.#
...##.
#....#
..#...
#.#..#
####..
""".lines
        XCTAssertEqual(17, day.part2(input, steps: 5))
    }
}
