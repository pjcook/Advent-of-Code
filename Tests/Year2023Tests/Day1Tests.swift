import XCTest
import InputReader
import Year2023

class Day1Tests: XCTestCase {
    
    let input = Input("Day1.input", Bundle.module).lines
    let day = Day1()

    func test_part1() {
//        measure {
        XCTAssertEqual(53194, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".lines
        XCTAssertEqual(142, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(54249, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
""".lines
        XCTAssertEqual(281, day.part2(input))
    }
    
    func test_extractNumbers() {
        XCTAssertEqual([2,1,8,3], "two1gvfxcqnrfnbeightthreexznhbmmk".extractNumbers())
        XCTAssertEqual([9,2,9,2], "ninehthhgbfsrrbpn2qpcflhgdvh9twotpzkvzmmsj".extractNumbers())
        XCTAssertEqual([8,6,3,9,3,9], "eightrpzsdggsixthree9dhrnqtjcbxthree9".extractNumbers())
        XCTAssertEqual([7,3,4,6,6,5], "seventhree4lnxcvdprp66hsjfive".extractNumbers())
        XCTAssertEqual([3], "sxhl3kc".extractNumbers())
    }
}
