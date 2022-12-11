import XCTest
import InputReader
import Year2022

class Day11Tests: XCTestCase {
    
//    let input = Input("Day11.input", Bundle.module).lines
    let day = Day11()

    func test_part1() {
//        measure {
        XCTAssertEqual(62491, day.part1(day.monkeys()))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(17408399184, day.part2(day.monkeys()))
//        }
    }
}

extension Day11Tests {
    func test_part1_example() {
        XCTAssertEqual(10605, day.part1(day.testMonkeys()))
    }
    
    func test_part2_example() {
        XCTAssertEqual(2713310158, day.part2(day.testMonkeys()))
    }
}
