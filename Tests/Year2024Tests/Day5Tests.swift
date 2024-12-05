import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).lines
    let day = Day5()

    func test_part1() {
//        measure {
        XCTAssertEqual(4872, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(5564, day.part2(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
""".lines
        XCTAssertEqual(143, day.part1(input))
    }
    
    func test_part2_example() {
        let input = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
""".lines
        XCTAssertEqual(123, day.part2(input))
    }
}
