import XCTest
import InputReader
import StandardLibraries
import Year2021

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Year2021.bundle).lines
    let day = Day19()

    func test_part1() {
        XCTAssertEqual(442, day.part1(input))
    }
    
    func test_part2() {
        XCTAssertEqual(11079, day.part2(input))
    }
    
    func test_parsing() {
        let scanners = day.parse(input)
        XCTAssertEqual(39, scanners.count)
//        XCTAssertEqual(26, scanners[0].calculateFaces().first!.count)
//        XCTAssertEqual(325, scanners[0].distances.count)
    }
}
