import XCTest
import InputReader
import Year2015

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Year2015.bundle).lines
    let day = Day5()

    func test_part1() {
        XCTAssertEqual(236, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(51, day.part2(input))
    }
    
    func test_part2_example() {
        XCTAssertEqual(1, day.part2(["rxexcbwhiywwwwnu"]))
        XCTAssertEqual(1, day.part2(["qjhvhtzxzqqjkmpb"]))
        XCTAssertEqual(1, day.part2(["xxyxx"]))
        XCTAssertEqual(0, day.part2(["uurcxstgmygtbstg"]))
        XCTAssertEqual(0, day.part2(["ieodomkazucvgmuy"]))
    }
}
