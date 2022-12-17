import XCTest
import InputReader
import Year2022

class Day17Tests: XCTestCase {
    
    let input = Input("Day17.input", Bundle.module).input
    let day = Day17()

    func test_part1() {
//        measure {
        XCTAssertEqual(3133, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1, day.part1(input, numberOfRocks: 1_000_000_000_000, shouldCleanup: true))
//        }
    }
}

extension Day17Tests {
    func test_part1_example() {
        let input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
        print(input.count)
        XCTAssertEqual(3068, day.part1(input))
    }
    
    func test_part2_example() {
        let input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
        XCTAssertEqual(1514285714288, day.part1(input, numberOfRocks: 1_000_000_000_000, shouldCleanup: true))
    }
}
