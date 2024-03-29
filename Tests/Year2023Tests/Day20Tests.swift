import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).lines
    let day = Day20()

    func test_part1() {
//        measure {
        XCTAssertEqual(763500168, day.part1(input))
//        }
    }
    
    func test_part1_example1() {
        let input = """
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
""".lines
        XCTAssertEqual(32000000, day.part1(input))
    }
    
    func test_part1_example2() {
        let input = """
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
""".lines
        XCTAssertEqual(11687500, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1, day.part2(input))
//        }
    }
    
    func test_part1b() {
//        measure {
        let day = Day20b()
        XCTAssertEqual(763500168, day.part1(input))
//        }
    }
    
    func test_part2b() {
//        measure {
        let day = Day20b()
        XCTAssertEqual(207652583562007, day.part2(input))
//        }
    }
}
