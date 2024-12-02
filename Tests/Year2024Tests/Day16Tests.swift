import XCTest
import InputReader
import Year2024

class Day16Tests: XCTestCase {
    
    let input = Input("Day16.input", Bundle.module).lines
    let day = Day16()

    func test_part1() {
//        measure {
        XCTAssertEqual(7951, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
""".lines
        XCTAssertEqual(46, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(8148, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
""".lines
        XCTAssertEqual(51, day.part2(input))
    }
}
