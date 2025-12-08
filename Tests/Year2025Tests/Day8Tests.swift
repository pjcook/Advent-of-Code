import XCTest
import InputReader
import StandardLibraries
import Year2025

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Bundle.module).lines
    let day = Day8()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(140008, day.part1(input, iterations: 1000))
//                }
    }

    func test_part1_example() throws {
        let input = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
""".lines
        XCTAssertEqual(40, day.part1(input, iterations: 10))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(9253260633, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
""".lines
        XCTAssertEqual(25272, day.part2(input))
    }
}
