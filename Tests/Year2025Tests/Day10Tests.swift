import XCTest
import InputReader
import Year2025

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", Bundle.module).lines
    let day = Day10()

    func test_part1() throws {
        //        measure {
        XCTAssertEqual(432, day.part1(input))
        //        }
    }

    func test_part1_example() throws {
        let input = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
""".lines
        XCTAssertEqual(7, day.part1(input))
    }

    func test_part2() throws {
        //        measure {
        XCTAssertEqual(0, day.part2(input))
        //        }
    }

    func test_part2_example() throws {
        let input = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
""".lines
        XCTAssertEqual(33, day.part2(input))
    }

    func test_part2_example2() throws {
        let input = """
[#...#] (1,2,3,4) (0,2,3,4) (0,1,2,3) {151,33,171,171,158}
""".lines
        XCTAssertEqual(171, day.part2(input))
    }

    func test_part2_example3() throws {
        let input = """
[.#..#.#...] (0,1,2,4,5,6,7,8) (0,1) (2,4,7,8) (0,2,3,6,8) (1,2,4) (0,2,4,7) (0,1,3,4,5,6,7,8,9) (2,3,4,5,9) (0,1,2,6,7,9) (0,1,2,4,5,8) (2,3,6,8,9) (1,4) {64,61,209,168,192,145,58,53,49,169}
""".lines
        XCTAssertEqual(171, day.part2(input))
    }
}
/*
 (1,2,3,4) (0,2,3,4) (0,1,2,3) {151,33,171,171,158}
 (1,2,3,4) (0,2,3,4) (0,1,2,3) {151,13,151,151,138}
 (1,2,3,4) (0,2,3,4) (0,1,2,3) {138,0,138,138,138}
 */

/*
 (2,4,6) (2,3) (0,1,2,3,5) (0,2,3,4,5) (1,5,6) (1,2,3,5,6) (0,3) {18,38,54,48,16,48,36}
 */
