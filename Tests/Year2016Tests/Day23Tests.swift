import XCTest
import InputReader
import Year2016

class Day23Tests: XCTestCase {
    
    let input = Input("Day23.input", Bundle.module).lines
    let day = Day23()

    func test_part1() {
//        measure {
        XCTAssertEqual(12573, day.part1(input, a: 7))
//        }
    }
    
    func test_part1_example() {
        let input = """
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
""".lines
        XCTAssertEqual(3, day.part1(input))
    }

    func test_part2() {
//        measure {
        XCTAssertEqual(479009133, day.part1(input, a: 12))
//        }
    }
}
