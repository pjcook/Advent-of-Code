import XCTest
import InputReader
import Year2023

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", Bundle.module).lines
    let day = Day10()

    func test_part1() {
//        measure {
        XCTAssertEqual(7086, day.part1(input))
//        }
    }

    func test_part1_example1() {
        let input = """
.....
.S-7.
.|.|.
.L-J.
.....
""".lines
        XCTAssertEqual(4, day.part1(input))
    }
    
    func test_part1_example2() {
        let input = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
""".lines
        XCTAssertEqual(8, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(317, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
""".lines
        XCTAssertEqual(8, day.part2(input))
    }
    
    func test_part2_example2() {
        let input = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
""".lines
        XCTAssertEqual(10, day.part2(input))
    }
}
