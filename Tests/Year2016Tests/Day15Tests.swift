import XCTest
import InputReader
import Year2016

class Day15Tests: XCTestCase {
    
    let input = Input("Day15.input", Bundle.module).lines
    let day = Day15()

    func test_part1() {
//        measure {
        XCTAssertEqual(400589, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
""".lines
        XCTAssertEqual(5, day.part1(input))
    }
    
    func test_part2() {
        var input2 = input
        input2.append("Disc #7 has 11 positions; at time=0, it is at position 0.")
        
//        measure {
        XCTAssertEqual(3045959, day.part1(input2))
//        }
    }
}
