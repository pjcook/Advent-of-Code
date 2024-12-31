import XCTest
import InputReader
import Year2016

class Day20Tests: XCTestCase {
    
    let input = Input("Day20.input", Bundle.module).lines
    let day = Day20()

    func test_part20() {
//        measure {
        XCTAssertEqual(19449262, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
5-8
0-2
4-7
""".lines
        XCTAssertEqual(3, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        // Low  4294967012
        // High 4294967177
        XCTAssertEqual(119, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
5-8
0-2
4-7
""".lines
        XCTAssertEqual(4294967288, day.part2(input))
    }
    
    func test_example() {
        let range1 = 1...3
        let range2 = 6...9
        let range3 = 2...5
        
        XCTAssertTrue(range1.overlaps(range3))
        XCTAssertFalse(range2.overlaps(range1))
        XCTAssertFalse(range2.overlaps(range3))
        
        let range4 = min(range1.lowerBound, range3.lowerBound)...max(range1.upperBound, range3.upperBound)
        XCTAssertTrue(range1.overlaps(range4))
        XCTAssertTrue(range3.overlaps(range4))
        XCTAssertFalse(range2.overlaps(range4))
        print(range4)
    }
}
