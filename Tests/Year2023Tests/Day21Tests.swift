import XCTest
import InputReader
import Year2023

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
//        measure {
        XCTAssertEqual(3733, day.part1(input, steps: 64))
//        }
    }
    
    func test_part1_example() {
        let input = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".lines
        XCTAssertEqual(16, day.part1(input, steps: 6))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(617729401414635, day.part2b(input, steps: 26501365))
//        }
    }
    
    func test_part2_example() {
        let input = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".lines
        XCTAssertEqual(16, day.part2(input, steps: 6))
//        XCTAssertEqual(50, day.part2(input, steps: 10))
//        XCTAssertEqual(1594, day.part2(input, steps: 50))
//        XCTAssertEqual(6536, day.part2(input, steps: 100))
//        XCTAssertEqual(167004, day.part2(input, steps: 500))
//        XCTAssertEqual(668697, day.part2(input, steps: 1000))
//        XCTAssertEqual(16733044, day.part2(input, steps: 5000))
    }
    
    func test_part2b_example() {
        let input = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".lines
//        XCTAssertEqual(16, day.part2b(input, steps: 6))
//        XCTAssertEqual(50, day.part2b(input, steps: 10))
//        XCTAssertEqual(1594, day.part2b(input, steps: 50))
//        XCTAssertEqual(6536, day.part2b(input, steps: 100))
//        XCTAssertEqual(167004, day.part2b(input, steps: 500))
//        XCTAssertEqual(668697, day.part2b(input, steps: 1000))
        XCTAssertEqual(16733044, day.part2b(input, steps: 5000))
    }
}
