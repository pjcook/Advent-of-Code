import XCTest
import InputReader
import Year2020

class Day14Tests: XCTestCase {
    let input = Input("Day14.input", Year2020.bundle).lines
    let day = Day14()

    func test_part1() {
        measure {
        XCTAssertEqual(8566770985168, day.part1(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(4832039794082, day.part2(input))
        }
    }
    
    func test_part1_example() {
        let input = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """.lines
        XCTAssertEqual(165, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
        """.lines
        XCTAssertEqual(208, day.part2(input))
    }
}
