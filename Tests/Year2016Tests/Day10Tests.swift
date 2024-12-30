import XCTest
import InputReader
import Year2016

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", Bundle.module).lines
    let day = Day10()

    func test_part1() {
//        measure {
        XCTAssertEqual(181, day.part1(input, find: [17, 61]))
//        }
    }
    
    func test_part1_example() {
        let input = """
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
""".lines
        XCTAssertEqual(2, day.part1(input, find: [2,5]))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(12567, day.part2(input))
//        }
    }
}
