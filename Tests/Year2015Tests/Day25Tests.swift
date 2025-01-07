import XCTest
import InputReader
import StandardLibraries
import Year2015

class Day25Tests: XCTestCase {
    
    let day = Day25()

    func test_part1() {
        XCTAssertEqual(19980801, day.part1(Point(3029,2947)))
    }
    
    func test_part1_example() {
        XCTAssertEqual(21345942, day.part1(Point(3,4)))
    }
    
    func test_calculate() {
        XCTAssertEqual(18, day.convert(point: Point(3,4)))
        XCTAssertEqual(6, (1...3).reduce(0, +))
        XCTAssertEqual(31916031, day.calculate(value: 20151125))
    }
    
    func test_stuff() {
        let point = Point(3,4)
        let x = (1...point.x).reduce(0, +)
        XCTAssertEqual(6, x)
        let dy = (0..<point.y-1).reduce(x) { $0 + point.x + $1}
        XCTAssertEqual(18, dy)
    }
}
