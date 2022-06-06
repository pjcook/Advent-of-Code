import XCTest
import InputReader
import Year2015

class Day11Tests: XCTestCase {
    
    let day = Day11()

    func test_part1() {
        XCTAssertEqual("vzbxxyzz", day.part1(["v","z","b","x","k","g","h","b"]))
    }
    
    func test_part2() {
        XCTAssertEqual("vzcaabcc", day.part2(["v","z","b","x","x","y","z","z"]))
    }
    
    func test_examples() {
        XCTAssertFalse(day.isValid(["h","i","j","k","l","m","m","n"]))
        XCTAssertTrue(day.hasStraight(["h","i","j","k","l","m","m","n"]))

        XCTAssertFalse(day.isValid(["a","b","b","c","e","f","f","g"]))
        XCTAssertTrue(day.hasNonOverlappingPairs(["a","b","b","c","e","f","f","g"]))

        XCTAssertFalse(day.isValid(["a","b","b","c","e","g","j","k"]))
        XCTAssertFalse(day.hasStraight(["a","b","b","c","e","g","j","k"]))
        XCTAssertFalse(day.hasNonOverlappingPairs(["a","b","b","c","e","g","j","k"]))
    }
}
