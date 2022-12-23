import XCTest
import InputReader
import Year2022

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Bundle.module).lines
    let day = Day23()

    func test_part1() {
//        measure {
        XCTAssertEqual(4138, day.part1(input, numberOfRounds: 10))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1010, day.part2(input))
//        }
    }
}

extension Day23Tests {
    func test_part1_example() {
        let input = """
.....
..##.
..#..
.....
..##.
.....
""".lines
        XCTAssertEqual(25, day.part1(input, numberOfRounds: 10))
    }
    
    func test_part1_example_larger() {
        let input = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
""".lines
        XCTAssertEqual(110, day.part1(input, numberOfRounds: 10))
    }
    
    func test_part2_example() {
        let input = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
""".lines
        XCTAssertEqual(20, day.part2(input))
    }
}
