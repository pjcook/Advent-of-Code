import XCTest
import InputReader
import Year2024

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).lines
    let day = Day11()

    func test_part1() {
//        measure {
        XCTAssertEqual(9805264, day.solve(input, multiplier: 2))
//        }
    }
    
    func test_part1_example() {
        let input = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
""".lines
        XCTAssertEqual(374, day.solve(input, multiplier: 2))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(779032247216, day.solve(input, multiplier: 1_000_000))
//        }
    }
    
    func test_part2_example() {
        let input = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
""".lines
        XCTAssertEqual(1030, day.solve(input, multiplier: 10))
        XCTAssertEqual(8410, day.solve(input, multiplier: 100))
    }
}
