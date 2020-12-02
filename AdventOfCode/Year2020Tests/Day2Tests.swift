import XCTest
import InputReader
@testable import Year2020

class Day2Tests: XCTestCase {
    var input: [Day2.PasswordItem] = []
    
    override func setUpWithError() throws {
        let input = try Input("Day2.input", Year2020.bundle)
        self.input = input.lines.compactMap(Day2.PasswordItem.init)
    }

    func test_part1() throws {
        let day2 = Day2()
        let result = input.filter { day2.validate($0) }.count
        XCTAssertEqual(519, result)
    }
    
    func test_part2() throws {
        let day2 = Day2()
        let result = input.filter { day2.validate2($0) }.count
        XCTAssertEqual(708, result)
    }
}
