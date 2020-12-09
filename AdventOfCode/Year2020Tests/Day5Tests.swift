import XCTest
import InputReader
@testable import Year2020

class Day5Tests: XCTestCase {
    let input = Input("Day5.input", Year2020.bundle)
            
    func test_part1() {
        XCTAssertEqual(855, Day5.parse(input.lines).sorted().last)
    }
    
    func test_part2() {
        let list = Day5.parse(input.lines).sorted()
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
    
    func test_part1_v2() {
        let result = input.input
            .replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "R", with: "1")
            .lines
            .compactMap { Int($0, radix: 2) }
            .sorted()
            .last
        XCTAssertEqual(855, result)
    }
    
    func test_part2_v2() {
        let list = input.input
            .replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "R", with: "1")
            .lines
            .compactMap { Int($0, radix: 2) }
            .sorted()
        
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
