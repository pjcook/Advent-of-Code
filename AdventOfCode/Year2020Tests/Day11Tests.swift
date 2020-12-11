import XCTest
import InputReader
@testable import Year2020

class Day11Tests: XCTestCase {
    let input = Input("Day11.input", Year2020.bundle).lines.compactMap({ $0.compactMap({ Character(extendedGraphemeClusterLiteral: $0) }) })
    let inputDict = Day11_v2.toDict(Input("Day11.input", Year2020.bundle).lines)

    func test_part1() throws {
        let day = Day11()
        XCTAssertEqual(2243, day.part1(input))
    }
    
    func test_part2() throws {
        let day = Day11()
        XCTAssertEqual(2027, day.part2(input))
    }
    
    func test_part1_example() {
        let input = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """.lines.compactMap({ $0.compactMap({ Character(extendedGraphemeClusterLiteral: $0) }) })
        let day = Day11()
        XCTAssertEqual(37, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """.lines.compactMap({ $0.compactMap({ Character(extendedGraphemeClusterLiteral: $0) }) })
        let day = Day11()
        XCTAssertEqual(26, day.part2(input))
    }
    
    func test_part1_example_v2() {
        let input = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """.lines
        let day = Day11_v2()
        XCTAssertEqual(37, day.part1(Day11_v2.toDict(input)))
    }
    
    func test_part1_v2() {
        let day = Day11_v2()
        XCTAssertEqual(2243, day.part1(inputDict))
    }
    
    func test_part2_example_v2() {
        let input = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """.lines
        let day = Day11_v2()
        XCTAssertEqual(26, day.part2(Day11_v2.toDict(input)))
    }
    
    func test_part2_v2() {
        let day = Day11_v2()
        XCTAssertEqual(2027, day.part2(inputDict))
    }
}
