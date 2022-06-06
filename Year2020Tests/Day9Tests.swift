import XCTest
import InputReader
import Year2020

class Day9Tests: XCTestCase {
    let input = Input("Day9.input", Year2020.bundle)
    
    func test_part1() {
//        self.measure {
        let input = self.input.lines.compactMap { Int($0) }
        let day = Day9()
        XCTAssertEqual(257342611, day.part1(input))
//        }
    }
    
    func test_part2() {
//        self.measure {
        let input = self.input.lines.compactMap { Int($0) }
        let day = Day9()
        XCTAssertEqual(35602097, day.part2(input))
//        }
    }
    
    func test_part2_chris() {
//        self.measure {
        let input = self.input.lines.compactMap { Int($0) }
        let day = Day9()
        XCTAssertEqual(35602097, day.part2(input))
//        }
    }
}
