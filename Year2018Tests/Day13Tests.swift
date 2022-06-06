import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day13Tests: XCTestCase {
    let input = Input("Day13.input", Year2018.bundle, trimming: false).lines
    
    func test_part1() {
        let day = Day13()
        let position = day.part1(input)
        XCTAssertEqual("103,85", "\(position.x),\(position.y)")
    }
    
    func test_part2() {
        let day = Day13()
        let position = day.part2(input)
        // "55,21" "44,80"
        XCTAssertEqual("88,64", "\(position.x),\(position.y)")
    }
    
    func test_part1_example() {
        let day = Day13()
        let input = Input("Day13_example1.input", Year2018.bundle).lines
        let position = day.part1(input)
        XCTAssertEqual("7,3", "\(position.x),\(position.y)")
    }
    
    func test_part2_example() {
        let day = Day13()
        let input = Input("Day13_example2.input", Year2018.bundle).lines
        let position = day.part2(input)
        XCTAssertEqual("6,4", "\(position.x),\(position.y)")
    }
}
