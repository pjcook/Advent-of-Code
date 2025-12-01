import XCTest
import InputReader
import Year2025

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).lines
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(1018, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
""".lines
        XCTAssertEqual(3, day.part1(input))
    }

    
    func test_part2() {
//        measure {
        XCTAssertEqual(5815, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
""".lines
        XCTAssertEqual(6, day.part2(input))
    }

    func test_part2_example2() {
        let input = """
R1000
""".lines
        XCTAssertEqual(10, day.part2(input))
    }

    func test_part2_example3() {
        let input = """
L7
R657
""".lines
        XCTAssertEqual(7, day.part2(input))
    }
}

