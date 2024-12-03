import XCTest
import InputReader
import Year2024

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Bundle.module).lines
    let day = Day3()

    func test_part1() throws {
//        measure {
        XCTAssertEqual(159833790, try day.part1(input))
//        }
    }
    
    func test_part1_example() throws {
        let input = """
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
""".lines
        XCTAssertEqual(161, try day.part1(input))
    }
    
    func test_part2() throws {
//        measure {
        XCTAssertEqual(89349241, day.part2(input))
//        }
    }
    
    func test_part2_example() throws {
        let input = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
""".lines
        XCTAssertEqual(48, day.part2(input))
    }
    
    func test_lookup() throws {
        XCTAssertTrue(day.lookup("xmul(2,4)", i: 1, value: "mul(", inputLength: 9))
    }
}
