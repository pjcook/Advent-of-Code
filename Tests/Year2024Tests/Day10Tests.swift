import XCTest
import InputReader
import Year2024

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", Bundle.module).lines
    let day = Day10()

    func test_part1() {
//        measure {
        XCTAssertEqual(667, day.part1(input))
//        }
    }

    func test_part1_example1() {
        let input = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
""".lines
        XCTAssertEqual(36, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1344, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
""".lines
        XCTAssertEqual(81, day.part2(input))
    }
}
