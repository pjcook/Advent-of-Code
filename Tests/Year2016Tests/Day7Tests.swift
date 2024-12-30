import XCTest
import InputReader
import Year2016

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual(115, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
abba[mnop]qrst
abcd[bddb]xyyx
aaaa[qwer]tyui
ioxxoj[asdfgh]zxcvbn
""".lines
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(231, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
aba[bab]xyz
xyx[xyx]xyx
aaa[kek]eke
zazbz[bzb]cdb
""".lines
        XCTAssertEqual(3, day.part2(input))
    }
}
