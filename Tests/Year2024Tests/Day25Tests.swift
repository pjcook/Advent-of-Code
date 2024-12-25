import XCTest
import InputReader
import Year2024

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Bundle.module).lines
    let day = Day25()

    func test_part1() {
//        measure {
        XCTAssertEqual(3327, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        /* hfx/pzl, bvb/cmg, nvd/jqt */
        let input = """
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
""".lines
        XCTAssertEqual(3, day.part1(input))
    }
}
