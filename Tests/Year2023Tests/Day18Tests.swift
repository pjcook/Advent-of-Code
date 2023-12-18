import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", Bundle.module).lines
    let day = Day18()

    func test_part1() {
//        measure {
        XCTAssertEqual(35401, day.part1Shoelace(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
""".lines
        XCTAssertEqual(62, day.part1(input))
    }
    
    func test_part1_shoelaceTheorum() {
        let input = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
""".lines
        XCTAssertEqual(62, day.part1Shoelace(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(48020869073824, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
""".lines
        XCTAssertEqual(952_408_144_115, day.part2(input))
    }
}
