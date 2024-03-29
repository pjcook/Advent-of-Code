import XCTest
import InputReader
import Year2020

class Day8Tests: XCTestCase {
    let input = Input("Day8.input", .module)
    
    // MARK: - using enums
    func test_part1() {
        let day = Day8()
        XCTAssertEqual(1475, day.part1(input.lines))
    }
    
    func test_part2() {
        let day = Day8()
        XCTAssertEqual(1270, day.part2(input.lines))
    }
    
    // MARK: - using strings
    func test_part1_v2() {
        let day = Day8()
        XCTAssertEqual(1475, day.part1_v2(input.lines))
    }
    
    func test_part2_v2() {
        let day = Day8()
        XCTAssertEqual(1270, day.part2_v2(input.lines))
    }
    
    // MARK: - using integers
    func test_part1_v3() {
        let day = Day8()
        XCTAssertEqual(1475, day.part1_v3(input.lines))
    }
    
    func test_part2_v3() {
        let day = Day8()
        XCTAssertEqual(1270, day.part2_v3(input.lines))
    }
    
    // MARK: - different parsing options
    func test_parsing() {
        XCTAssertEqual(635, input.lines.compactMap(Instruction.parse).count)
    }
    
    func test_parsing2() {
        XCTAssertEqual(635, input.lines.map { $0.split(separator: " ") }.count)
    }
    
    func test_parsing3() {
        let day = Day8()
        let results = input
            .lines
            .map {
                $0.split(separator: " ")
                    .map(day.tokenize)
            }
        XCTAssertEqual(635, results.count)
    }
    
    func test_parsing4() {
        let results = input.lines.compactMap(Instruction.parse2)
        XCTAssertEqual(635, results.count)
    }
    
    // MARK: - processing example code
    func test_part1_example() {
        let input = """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        """
        let day = Day8()
        XCTAssertEqual(5, day.part1(input.lines))
    }
    
    func test_part2_example() {
        let input = """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        """
        let day = Day8()
        XCTAssertEqual(8, day.part2(input.lines))
    }
}
