import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day17Tests: XCTestCase {
    
    let input = Input("Day17.input", Bundle.module).lines
    let day = Day17()

    // Had to run someone elses Python solution
    // Credit Jonathan Paulson https://github.com/jonathanpaulson/AdventOfCode/blob/master/2023/17.py
    // Source is in Day17.py needed to run via the `IDLE` app
    
//    func test_part1() {
////        measure {
//        XCTAssertEqual(665, day.part1(input))
////        }
//    }
    
    func test_part1_grid() {
        let grid = Grid<Int>(input)
        XCTAssertEqual(141, grid.columns)
        XCTAssertEqual(141, grid.rows)
    }
    
    func test_part1_example() {
        let input = """
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
""".lines
        XCTAssertEqual(102, day.part1(input))
    }
    
//    func test_part2() {
////        measure {
//        XCTAssertEqual(809, day.part2(input))
////        }
//    }
}
