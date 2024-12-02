import XCTest
import InputReader
import Year2024

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Bundle.module).lines
    let day = Day13()

    func test_part1() {
//        measure {
        XCTAssertEqual(33356, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
""".lines
        XCTAssertEqual(405, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(28475, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
""".lines
        XCTAssertEqual(400, day.part2(input))
    }
    
    func test_part2_example2() {
        let input = """
......#
###.#..
###.##.
###.##.
###.#..
.....##
##..#..
##.#...
.###.#.
##.....
..#...#
#....##
#....##
..#...#
##.....
""".lines
        XCTAssertEqual(1200, day.part1(input))
        XCTAssertEqual(300, day.part2(input))
    }
}
