import XCTest
import InputReader
import Year2022

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).lines
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(70764, day.part1(input))
//        }
    }
    
    func test_part1_optimised() {
//        measure {
        XCTAssertEqual(70764, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(203905, day.part2(input))
//        }
    }
    
    func test_part2_optimised() {
//        measure {
        XCTAssertEqual(203905, day.part2(input))
//        }
    }
}
