import XCTest
import InputReader
import Year2016

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", Bundle.module).lines
    let day = Day21()

    func test_part1() {
//        measure {
        XCTAssertEqual("agcebfdh", day.part1(input, value: "abcdefgh"))
//        }
    }
    
    func test_part1_example() {
        let input = """
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
""".lines
        XCTAssertEqual("decab", day.part1(input, value: "abcde"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("afhdbegc", day.part2(input, value: "fbgdceah"))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual("abcdefgh", day.part2(input, value: "agcebfdh"))
    }
}
