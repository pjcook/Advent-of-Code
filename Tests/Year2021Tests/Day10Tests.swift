import XCTest
import InputReader
import Year2021

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", .module).lines
    let day = Day10()

    func test_part1() {
//        measure {
        XCTAssertEqual(299793, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(3654963618, day.part2(input))
//        }
    }
    
    func test_examples() {
        XCTAssertEqual(.invalid("}"), day.parse("{([(<{}[<>[]}>{[]{[(<()>"))
        XCTAssertEqual(.invalid(")"), day.parse("[[<[([]))<([[{}[[()]]]"))
        XCTAssertEqual(.invalid("]"), day.parse("[{[{({}]{}}([{[{{{}}([]"))
        XCTAssertEqual(.invalid(")"), day.parse("[<(<(<(<{}))><([]([]()"))
        XCTAssertEqual(.invalid(">"), day.parse("<{([([[(<>()){}]>(<<{{"))
        
        let input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
""".lines
        XCTAssertEqual(26397, day.part1(input))
    }
}
