import XCTest
import InputReader
import Year2025

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).input
    let day = Day2()

    func test_part1() throws {
//                measure {
        XCTAssertEqual(18700015741, day.part1(input))
//                }
    }

    func test_part1_example() throws {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        XCTAssertEqual(1227775554, day.part1(input))
    }

    func test_part2() throws {
//                measure {
        XCTAssertEqual(20077272987, day.part2(input))
//                }
    }

    func test_part2_example() throws {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        XCTAssertEqual(4174379265, day.part2(input))
    }

    func test_chunked() throws {
        XCTAssertEqual(["He", "ll", "o ", "wo", "rl", "d!"], "Hello world!".chunked(size: 2))
        XCTAssertEqual(["123", "123", "123"], "123123123".chunked(size: 3))
        XCTAssertEqual(["1234", "1234"], "12341234".chunked(size: 4))
    }
}
