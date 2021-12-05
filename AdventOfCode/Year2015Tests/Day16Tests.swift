import XCTest
import InputReader
import Year2015

class Day16Tests: XCTestCase {
    
    let input = Input("Day16.input", Year2015.bundle).lines
    let day = Day16()
    let tickerTape = [
        "children": 3,
        "cats": 7,
        "samoyeds": 2,
        "pomeranians": 3,
        "akitas": 0,
        "vizslas": 0,
        "goldfish": 5,
        "trees": 3,
        "cars": 2,
        "perfumes": 1
    ]
    
    func test_part1() throws {
        XCTAssertEqual(40, try day.part1(input, tickerTape: tickerTape))
    }
    
    func test_part2() throws {
        XCTAssertEqual(241, try day.part2(input))
    }
    
    func test_parsing() throws {
        let info = try day.parse(input)
        XCTAssertEqual(500, info.count)
    }
}
