import XCTest
import InputReader
import Year2020

class Day2Tests: XCTestCase {
    let input = Input("Day2.input", .module).lines.compactMap(Day2.PasswordItem.init)

    func test_part1() {
        let day2 = Day2()
        let result = input.filter { day2.validate($0) }.count
        XCTAssertEqual(519, result)
    }
    
    func test_part2() {
        let day2 = Day2()
        let result = input.filter { day2.validate2($0) }.count
        XCTAssertEqual(708, result)
    }
}
