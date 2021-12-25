import XCTest
import InputReader
import Year2021

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Year2021.bundle).lines
    let day = Day25()

    func test_part1() {
        XCTAssertEqual(374, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_parse() {
        let grid = day.parse(input)
        XCTAssertEqual(137, grid.rows)
        XCTAssertEqual(139, grid.columns)
    }
    
    func test_example() {
        let input = """
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
""".lines
        XCTAssertEqual(58, day.part1(input))
    }
}
