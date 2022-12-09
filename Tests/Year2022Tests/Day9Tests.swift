import XCTest
import InputReader
import Year2022

class Day9Tests: XCTestCase {
    
    let input = Input("Day9.input", Bundle.module).lines
    let day = Day9()

    func test_part1() {
//        measure {
        XCTAssertEqual(6090, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2566, day.part2(input))
//        }
    }
}

extension Day9Tests {
    func test_parse() throws {
        let input = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
""".lines
        let results = day.parse(input)
        XCTAssertEqual(8, results.count)
        XCTAssertEqual(.right, results.first?.direction)
        XCTAssertEqual(4, results.first?.value)
    }
    
    func test_parse_input() throws {
//        measure {
            let results = day.parse(input)
            XCTAssertEqual(2000, results.count)
//        }
    }
    
    func test_part1_example() throws {
        let input = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
""".lines
        XCTAssertEqual(13, day.part1(input))
    }
    
    func test_part2_example() throws {
        let input = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
""".lines
        XCTAssertEqual(1, day.part2(input))
    }
    
    func test_part2_example2() throws {
        let input = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
""".lines
        XCTAssertEqual(36, day.part2(input))
    }
}
