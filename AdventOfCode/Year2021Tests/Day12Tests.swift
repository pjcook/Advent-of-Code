import XCTest
import InputReader
import Year2021

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Year2021.bundle).lines
    let day = Day12()

    func test_part1() {
        measure {
        XCTAssertEqual(3292, day.part1(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(89592, day.part2(input))
        }
    }
    
    func test_parsing() {
        let elements = day.parse(input)
        for item in elements {
            print(item)
        }
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
