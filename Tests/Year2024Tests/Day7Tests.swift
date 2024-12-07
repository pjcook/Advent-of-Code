import XCTest
import InputReader
import Year2024

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual(12940396350192, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
""".lines
        XCTAssertEqual(3749, day.part1(input))
    }
//    
//    func test_item() {
//        let item = Day7Item("190: 10 19 15")
//        let options = item.options(false)
//        print(options)
//        XCTAssertEqual(item.evaluate(options.first!), item.result)
//    }
//    
//    func test_evaluate() {
//        let item = Day7Item("292: 11 6 16 20")
//        XCTAssertEqual(item.evaluate("11 + 6 * 16 + 20"), item.result)
//    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(106016735664498, day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
""".lines
        XCTAssertEqual(11387, day.part2(input))
    }
}
