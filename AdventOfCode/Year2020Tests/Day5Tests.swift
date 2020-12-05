import XCTest
import InputReader
@testable import Year2020

class Day5Tests: XCTestCase {
    var input: [String] = []
        
    override func setUpWithError() throws {
        let input = try Input("Day5.input", Year2020.bundle)
        self.input = input.lines
    }
    
    func test_part1() throws {
        XCTAssertEqual(855, Day5.parse(input).sorted().last)
    }
    
    func test_part2() throws {
        let list = Day5.parse(input).sorted()
        var i = 0
        var seat = list[0]
        while true {
            seat += 1
            if list[i+1] != seat {
                break
            }
            i += 1
        }
        XCTAssertEqual(552, seat)
    }
    
    func test_binaryString() {
        XCTAssertEqual(567, Int("1000110111", radix: 2))
    }
}
