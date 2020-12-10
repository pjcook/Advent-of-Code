import XCTest
import InputReader
@testable import Year2020

class Day10Tests: XCTestCase {
    let input = Input("Day10.input", Year2020.bundle).integers.sorted()

    func test_part1() throws {
        measure {
        let day = Day10()
        XCTAssertEqual(2812, day.part1(input))
        }
    }
    
    func test_part2() throws {
        measure {
        let day = Day10()
        XCTAssertEqual(386869246296064, day.part2(input))
        }
    }
    
    func test_part1_example1() throws {
        let input = Input("""
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
        """).integers.sorted()
        let day = Day10()
        XCTAssertEqual(5 * 7, day.part1(input))
    }
    
    func test_part1_example2() throws {
        let input = Input("""
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """).integers.sorted()
        let day = Day10()
        XCTAssertEqual(22 * 10, day.part1(input))
    }
    
    func test_part2_example1() throws {
        let input = Input("""
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
        """).integers.sorted()
        let day = Day10()
        XCTAssertEqual(8, day.part2(input))
    }
    
    func test_part2_example2() throws {
        let input = Input("""
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """).integers.sorted()
        let day = Day10()
        XCTAssertEqual(19208, day.part2(input))
    }
    
    func test_range() {
        let value = 0
        let range = (value-3...value+3)
        XCTAssertTrue(range.contains(-3))
        XCTAssertTrue(range.contains(3))
    }
}
