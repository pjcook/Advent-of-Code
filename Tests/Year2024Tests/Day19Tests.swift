import XCTest
import InputReader
import Year2024

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Bundle.module).lines
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual(213, day.part1(input))
//        }
    }
    
    func test_part1_example1() {
        let input = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
""".lines
        XCTAssertEqual(6, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1016700771200474, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
""".lines
        XCTAssertEqual(16, day.part2(input))
    }
}
