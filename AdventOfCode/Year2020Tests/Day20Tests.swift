import XCTest
import InputReader
import Year2020

class Day20Tests: XCTestCase {
    let input = Input("Day20.input", Year2020.bundle).lines
    let day = Day20()

    func test_part1() {
        let parsed = try! day.parse(input)
        XCTAssertEqual(8425574315321, day.part1(parsed))
    }
    
    func test_part2() {
        let parsed = try! day.parse(input)
        XCTAssertEqual(0, day.part2(parsed))
    }
    
    func test_parsing() throws {
        let parsed = try day.parse(input)
        XCTAssertEqual(144, parsed.count)
    }
    
    func test_rotate() throws {
        let parsed = try day.parse(input)
        let tile = parsed.first!
        let rotated = tile.rotate
        
        print(tile.data)
        print(rotated.data)
    }
}
