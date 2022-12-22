import XCTest
import InputReader
import Year2022

class Day22Tests: XCTestCase {
    
    let input = Input("Day22.input", Bundle.module, trimming: false).lines
    let day = Day22()

    func test_part1() {
//        measure {
        XCTAssertEqual(144244, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(138131, day.part2(input, mappings: Day22.PuzzleMapping.all))
//        }
    }
}

extension Day22Tests {
    func test_part1_parse() {
        let input = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
""".lines
        let (grid, instructions) = day.parse(input)
        
        print(instructions)
        print()
        grid.draw()
    }
    
    func test_part1_example() {
        let input = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
""".lines
        XCTAssertEqual(6032, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
""".lines
        
        XCTAssertEqual(5031, day.part2(input, mappings: Day22.ExampleMapping.all))
    }
}
