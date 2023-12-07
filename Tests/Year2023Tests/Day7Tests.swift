import XCTest
import InputReader
import Year2023

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual(248422077, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".lines
        XCTAssertEqual(6440, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(249817836, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".lines
        XCTAssertEqual(5905, day.part2(input))
    }
}
