import XCTest
import InputReader
import Year2024

class Day21Tests: XCTestCase {
    
//    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
        let input = """
413A
480A
682A
879A
083A
""".lines
//        measure {
        XCTAssertEqual(177814, day.part1(input, chainLength: 2))
//        }
    }
    
    func test_part1_example() {
        let input = """
029A
980A
179A
456A
379A
""".lines
        // 127900
        XCTAssertEqual(126384, day.part1(input, chainLength: 2))
    }
    
    func test_part2() {
        let input = """
413A
480A
682A
879A
083A
""".lines
//        measure {
        XCTAssertEqual(617729401414635, day.part1(input, chainLength: 25))
//        }
    }
}
