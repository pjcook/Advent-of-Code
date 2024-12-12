import XCTest
import InputReader
import Year2024

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(1431316, day.part1(input))
//        }
    }
    
    func test_part1_example1() {
        let input = """
AAAA
BBCD
BBCC
EEEC
""".lines
        XCTAssertEqual(140, day.part1(input))
    }
    
    func test_part1_example2() {
        let input = """
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
""".lines
        XCTAssertEqual(772, day.part1(input))
    }
    
    func test_part1_example3() {
        let input = """
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
""".lines
        XCTAssertEqual(1930, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(821428, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
""".lines
        XCTAssertEqual(236, day.part2(input))
    }
    
    func test_part2_example2() {
        let input = """
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
""".lines
        XCTAssertEqual(368, day.part2(input))
    }
}
