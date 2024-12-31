import XCTest
import InputReader
import Year2016

class Day18Tests: XCTestCase {
    
    let input = Input("Day18.input", Bundle.module).input
    let day = Day18()

    func test_part1() {
//        measure {
        XCTAssertEqual(1951, day.part1(input, rowsToGenerate: 40))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(38, day.part1(".^^.^.^^^^", rowsToGenerate: 10))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(20002936, day.part1(input, rowsToGenerate: 400000))
//        }
    }
}
