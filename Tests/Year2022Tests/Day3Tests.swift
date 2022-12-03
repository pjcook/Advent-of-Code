import XCTest
import InputReader
import Year2022

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Bundle.module).lines
    let day = Day3()

    func test_part1() {
//        measure {
        XCTAssertEqual(7917, day.part1(input))
//        }
    }
    
    func test_part1_example() throws {
        let input = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
""".lines
        XCTAssertEqual(157, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2585, day.part2(input))
//        }
    }
    
    func test_part2_example() throws {
        let input = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
""".lines
        XCTAssertEqual(70, day.part2(input))
    }
    
    func test_lookup() throws {
        XCTAssertEqual(52, day.lookup.count)
        XCTAssertEqual(16, day.lookup["p"]!)
    }
}
