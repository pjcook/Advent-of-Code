import XCTest
import InputReader
import StandardLibraries
import Year2022

class Day5Tests: XCTestCase {
    
    let input = Input("Day5.input", Bundle.module).lines
    let day = Day5()

    func test_part1() throws {
//        measure {
        XCTAssertEqual("WHTLRMZRC", try! day.part1(input))
//        }
    }
    
    func test_part2() throws {
//        measure {
        XCTAssertEqual("GMPMLWNMG", try! day.part2(input))
//        }
    }
}

extension Day5Tests {
    func test_parse() throws {
        let input = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
""".lines
        let stacks = try day.parse(input, move: day.move)
        print(stacks)
    }
    
    func test_part1_example() throws {
        let input = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
""".lines
        XCTAssertEqual("CMZ", try day.part1(input))
    }
    
    func test_regex() throws {
        let regex = try RegularExpression(pattern: "[\\w]* ([\\d]+) [\\w]* ([\\d]+) [\\w]* ([\\d]+)")
        let line = "move 8 from 33 to 2"
        let match = try regex.match(line)
        let instruction = try (match.integer(at: 0), match.integer(at: 1), match.integer(at: 2))
        print(instruction)
    }
    
    func test_parsing() throws {
//        measure {
        _ = try! day.parse(input, move: day.move)
//        }
    }
}
