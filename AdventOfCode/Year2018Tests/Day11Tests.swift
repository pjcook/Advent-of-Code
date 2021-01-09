import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day11Tests: XCTestCase {
    func test_part1() {
        let day = Day11()
        let value = day.part1(5719)
        XCTAssertEqual("21,34", "\(value.x),\(value.y)")
    }
    
    func test_part2() {
        let day = Day11()
        let (point, size) = day.part2(5719)
        XCTAssertEqual("90,244,16", "\(point.x),\(point.y),\(size)")
    }
    
    func test_part1_example() {
        let day = Day11()
        let value = day.part1(42)
        XCTAssertEqual("21,61", "\(value.x),\(value.y)")
    }
    
    func test_part2_example1() {
        let day = Day11()
        let (point, size) = day.part2(18)
        XCTAssertEqual("90,269,16", "\(point.x),\(point.y),\(size)")
    }
    
    func test_calculatePowerLevel() {
        let day = Day11()
        XCTAssertEqual(4, day.calculatePowerLevel(3, 5, 8))
        XCTAssertEqual(-5, day.calculatePowerLevel(122, 79, 57))
        XCTAssertEqual(0, day.calculatePowerLevel(217, 196, 39))
        XCTAssertEqual(4, day.calculatePowerLevel(101, 153, 71))
    }
}
