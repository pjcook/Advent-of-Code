import XCTest
import InputReader
import Year2021

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", .module).lines
    let day = Day20()

    func test_part1() {
        // NOT 5405
        // TOO HIGH 5825
        // TOO HIGH 5244
        // NOT 5240
        // NOT 5235
        XCTAssertEqual(5231, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(14279, day.part2(input))
    }
    
    func test_example() {
        let input = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
""".lines
        XCTAssertEqual(35, day.part1(input))
    }
    
    func test_parsing() {
        let (algorithm, photo) = day.parse(input)
        XCTAssertEqual(512, algorithm.count)
        XCTAssertEqual(100, photo.pixels.rows)
        XCTAssertEqual(100, photo.pixels.columns)
        
        let paddedGrid = photo.pixels.padded(by: 2)
        XCTAssertEqual(104, paddedGrid.rows)
        XCTAssertEqual(104, paddedGrid.columns)
    }
}
