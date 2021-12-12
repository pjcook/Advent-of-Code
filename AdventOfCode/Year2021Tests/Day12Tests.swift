import XCTest
import InputReader
import Year2021

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Year2021.bundle).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(3292, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(89592, day.part2(input))
//        }
    }
    
    func test_part1b() {
//        measure {
        XCTAssertEqual(3292, day.solution2(input))
//        }
    }
    
    func test_part2b() {
//        measure {
        XCTAssertEqual(89592, day.solution2(input, allowRepeat: true))
//        }
    }
    
    func test_parsing() {
//        measure {
        _ = day.parse(input)
//        }
    }
    
    func test_parsing_slow() {
//        measure {
        _ = day.parse_slow(input)
//        }
    }
    
    func test_example1() {
        let input = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
""".lines
        XCTAssertEqual(10, day.part1(input))
    }
    
    func test_example2() {
        let input = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
""".lines
        XCTAssertEqual(36, day.part2(input))
    }
}
