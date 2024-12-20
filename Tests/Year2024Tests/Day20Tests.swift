import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).lines
    let day = Day20()

    func test_part1() {
//        measure {
        XCTAssertEqual(1321, day.part1(input, savingAtLeast: 100))
//        }
    }
    
    func test_part1_example1() {
        let input = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
""".lines
        XCTAssertEqual(43, day.part1(input, savingAtLeast: 0))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(971737, day.part2(input, savingAtLeast: 100))
//        }
    }
    
    func test_part2_example1() {
        let input = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
""".lines
        
        XCTAssertEqual(3, day.part2(input, savingAtLeast: 76))
        XCTAssertEqual(7, day.part2(input, savingAtLeast: 74))
        XCTAssertEqual(29, day.part2(input, savingAtLeast: 72))
        XCTAssertEqual(41, day.part2(input, savingAtLeast: 70))
        XCTAssertEqual(55, day.part2(input, savingAtLeast: 68))
        XCTAssertEqual(67, day.part2(input, savingAtLeast: 66))
        XCTAssertEqual(86, day.part2(input, savingAtLeast: 64))
        XCTAssertEqual(106, day.part2(input, savingAtLeast: 62))
        XCTAssertEqual(129, day.part2(input, savingAtLeast: 60))
        XCTAssertEqual(154, day.part2(input, savingAtLeast: 58))
        XCTAssertEqual(193, day.part2(input, savingAtLeast: 56))
        XCTAssertEqual(222, day.part2(input, savingAtLeast: 54))
        XCTAssertEqual(253, day.part2(input, savingAtLeast: 52))
        XCTAssertEqual(285, day.part2(input, savingAtLeast: 50))
    }
}


