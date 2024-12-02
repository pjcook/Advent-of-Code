import XCTest
import InputReader
import Year2024

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Bundle.module).lines
    let day = Day3()

    func test_part1() {
//        measure {
        XCTAssertEqual(529618, day.part1(input))
//        }
    }
    
    func test_part1_chris() {
        let input = Input("Day3_Chris.input", Bundle.module).lines
        XCTAssertEqual(546312, day.part1(input))
    }
    
    func test_part1_example() {
        let input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""".lines
        XCTAssertEqual(4361, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(77509019, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""".lines
        XCTAssertEqual(467835, day.part2(input))
    }
}
