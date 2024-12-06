import XCTest
import InputReader
import Year2024

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).lines
    let day = Day6()

    func test_part1() {
//        measure {
        XCTAssertEqual(4967, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""".lines
        XCTAssertEqual(41, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1789, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""".lines
        XCTAssertEqual(6, day.part2(input))
    }

}
