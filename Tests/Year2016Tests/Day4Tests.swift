import XCTest
import InputReader
import Year2016

class Day4Tests: XCTestCase {
    
    let input = Input("Day4.input", Bundle.module).lines
    let day = Day4()

    func test_part4() {
//        measure {
        XCTAssertEqual(1, day.part1(input))
//        }
    }
    
    func test_part4_example() {
        let input = """
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
""".lines
        XCTAssertEqual(1514, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(548, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual("very encrypted name", day.decrypt("qzmt-zixmtkozy-ivhz-343[abc]"))
    }
}
