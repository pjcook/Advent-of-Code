import XCTest
import InputReader
import Year2024

class Day4Tests: XCTestCase {
    
    let input = Input("Day4.input", Bundle.module).lines
    let day = Day4()

    func test_part1() {
//        measure {
        XCTAssertEqual(2569, day.part1(input))
//        }
    }
    
    func test_part1_chris() {
//        measure {
        XCTAssertEqual(2569, day.chrisPart1(input))
//        }
    }
    
    func test_part1_example_chris() {
        let input = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""".lines
        XCTAssertEqual(18, day.chrisPart1(input))
    }
    
    func test_part1_example() {
        let input = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""".lines
        XCTAssertEqual(18, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1998, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""".lines
        XCTAssertEqual(9, day.part2(input))
    }
}
