import XCTest
import InputReader
import Year2020

class Day16Tests: XCTestCase {
    let input = Input("Day16.input", Year2020.bundle).lines
    let day = Day16()
    let parser = Day16.Parser()

    func test_part1() {
        measure {
        let results = try! parser.parse(input)
        XCTAssertEqual(23115, day.part1(instructions: results.0, tickets: results.1))
        }
    }
    
    func test_part2() {
        measure {
        let results = try! parser.parse(input)
        XCTAssertEqual(239727793813, day.part2(instructions: results.0, tickets: results.1))
        }
    }
    
    func test_parsingWholeFile() throws {
        let results = try parser.parse(input)
        XCTAssertEqual(20, results.0.count)
        XCTAssertEqual(241, results.1.count)
    }
    
    func test_parsing() throws {
        let input = self.input[0]
        let regex = Day16.Parser().fieldRegex
        let match = try regex.match(input)
        XCTAssertEqual("departure location", try match.string(at: 0))
        XCTAssertEqual(35, try match.integer(at: 1))
        XCTAssertEqual(796, try match.integer(at: 2))
        XCTAssertEqual(811, try match.integer(at: 3))
        XCTAssertEqual(953, try match.integer(at: 4))
    }
    
    func test_range() {
        let range1 = (0...3)
        let range2 = (5...7)
        XCTAssertTrue(range1.contains(0) || range2.contains(0))
        XCTAssertTrue(range1.contains(3) || range2.contains(3))
        XCTAssertFalse(range1.contains(4) || range2.contains(4))
        XCTAssertTrue(range1.contains(5) || range2.contains(5))
        XCTAssertTrue(range1.contains(7) || range2.contains(7))
    }
}
