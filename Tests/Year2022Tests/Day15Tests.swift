import XCTest
import InputReader
import Year2022

class Day15Tests: XCTestCase {
    
    let input = Input("Day15.input", Bundle.module).lines
    let day = Day15()

    func test_part1() {
//        measure {
        XCTAssertEqual(5256611, day.part1(input, rowToCheck: 2_000_000))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(13337919186981, day.part2(input, upperBound: 4_000_000))
//        }
    }
}

extension Day15Tests {
    func test_part1_parse() {
        let input = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
""".lines
        let result = day.parse(input)
        XCTAssertEqual(14, result.count)
        
        XCTAssertEqual(2, result[0].0.x)
        XCTAssertEqual(18, result[0].0.y)
        XCTAssertEqual(-2, result[0].1.x)
        XCTAssertEqual(15, result[0].1.y)
        
        XCTAssertEqual(20, result[13].0.x)
        XCTAssertEqual(1, result[13].0.y)
        XCTAssertEqual(15, result[13].1.x)
        XCTAssertEqual(3, result[13].1.y)
    }
    
    func test_part1_example() {
        let input = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
""".lines
        XCTAssertEqual(26, day.part1(input, rowToCheck: 10))
    }
    
    func test_part2_example() {
        let input = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
""".lines
        XCTAssertEqual(56000011, day.part2(input, upperBound: 20))
    }
}
