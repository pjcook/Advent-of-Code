import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day21Tests: XCTestCase {
    
//    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
        let input = """
413A
480A
682A
879A
083A
""".lines
//        measure {
        XCTAssertEqual(177814, day.part1(input, chainLength: 2))
//        }
    }
    
    func test_part1_example() {
        let input = """
029A
980A
179A
456A
379A
""".lines
        // 127900
        XCTAssertEqual(126384, day.part1(input, chainLength: 2))
    }
    
    func test_part1_example2() {
        let input = """
029A
""".lines
        // 127900
        XCTAssertEqual(1972, day.part1(input, chainLength: 2))
    }
    
    func test_part2() {
        let input = """
413A
480A
682A
879A
083A
""".lines
//        measure {
        XCTAssertEqual(220493992841852, day.part2(input, chainLength: 25))
//        }
    }
    
    func test_part2b() {
        let input = """
413A
480A
682A
879A
083A
""".lines
//        measure {
        XCTAssertEqual(220493992841852, day.part2b(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
029A
""".lines
        XCTAssertEqual(1972, day.part2(input, chainLength: 2))
    }
    
    /*
     Checking 029A
     A 0 28 ["<A"]                  18
     0 2 20 ["^A"]                  12
     2 9 31 ["^^>A", ">^^A"]        20
     9 A 28 ["vvvA"]                18
     Result 029A 107 29
     */
    
    func test_part2_example2() {
        let input = """
029A
980A
179A
456A
379A
""".lines
        // 127900
        XCTAssertEqual(126384, day.part2(input, chainLength: 2))
    }
    
    func test_part2_example3() {
        let input = """
208A
540A
656A
879A
826A
""".lines
        // 163740426544460
        // 267793184559520
        XCTAssertEqual(267793184559520, day.part2(input, chainLength: 25))
    }
    
    func test_part2_example3b() {
        let input = """
208A
540A
656A
879A
826A
""".lines
        // 267793184559520
        XCTAssertEqual(267793184559520, day.part2b(input))
    }
    
    func test_generateSteps() {
        let input = """
789
456
123
X0A
"""
        print(Day21.generateSteps(str: input))
    }
}
