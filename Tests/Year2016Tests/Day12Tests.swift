import XCTest
import InputReader
import Year2016

class Day12Tests: XCTestCase {
    
    let input = Input("Day12.input", Bundle.module).lines
    let day = Day12()

    func test_part1() {
//        measure {
        XCTAssertEqual(318003, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
""".lines
        XCTAssertEqual(42, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(9227657, day.part2(input))
//        }
    }
}

/*
 a = 3
 b = 2
 c = 2
 d = 24
 */
