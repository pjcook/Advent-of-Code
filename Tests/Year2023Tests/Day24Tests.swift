import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day24Tests: XCTestCase {
    
    let input = Input("Day24.input", Bundle.module).lines
    let day = Day24()

    func test_part1() {
//        measure {
        XCTAssertEqual(1, day.part1(input, minValue: 200000000000000, maxValue: 400000000000000))
//        }
    }
    
    func test_part1_example() {
        let input = """
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
""".lines
        XCTAssertEqual(2, day.part1(input, minValue: 7, maxValue: 27))
    }
    
    func test_part1_example1() {
        // Hailstone A: 19, 13, 30 @ -2, 1, -2
        // Hailstone B: 18, 19, 22 @ -1, -1, -2
        // Hailstones' paths will cross inside the test area (at x=14.333, y=15.333).
        let p1a = Point(19,13)
        let p1b = p1a + Point(-2,1)
        let p2a = Point(18,19)
        let p2b = p2a + Point(-1,-1)
        
        guard let (x,y) = intersectionOfLines(line1: Line(p1: p1a, p2: p1b), line2: Line(p1: p2a, p2: p2b)) else {
            XCTFail()
            return
        }
        XCTAssertEqual(x, 14.333333333333334)
        XCTAssertEqual(y, 15.333333333333334)
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(1, day.part2(input))
//        }
    }
}
