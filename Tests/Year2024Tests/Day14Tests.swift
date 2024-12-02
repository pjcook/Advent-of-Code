import XCTest
import InputReader
import Year2024

class Day14Tests: XCTestCase {
    
    let input = Input("Day14.input", Bundle.module).lines
    let day = Day14()

    func test_part1() {
//        measure {
        XCTAssertEqual(113424, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".lines
        
        XCTAssertEqual(136, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(96003, day.part2(input, iterations: 1_000_000_000))
//        }
    }
    
    func test_part2_example() {
        let input = """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".lines
        
        XCTAssertEqual(64, day.part2(input, iterations: 1_000_000_000))
    }
}
