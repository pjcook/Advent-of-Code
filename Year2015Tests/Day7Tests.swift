import XCTest
import InputReader
import Year2015

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Year2015.bundle).lines
    let day = Day7()

    func test_part1() throws {
        try XCTAssertEqual(956, day.part1(input, calculate: "a"))
    }
    
    func test_part2() throws {
        var input2 = input
        input2.append("956 -> b")
        try XCTAssertEqual(40149, day.part1(input2, calculate: "a"))
    }
    
    func test_parsing() throws {
        let instructions = try day.parse(input)
        XCTAssertEqual(339, instructions.count)
    }
    
    func test_example() throws {
        let input = [
        "123 -> x",
        "456 -> y",
        "x AND y -> d",
        "x OR y -> e",
        "x LSHIFT 2 -> f",
        "y RSHIFT 2 -> g",
        "NOT x -> h",
        "NOT y -> i",
        ]
        let instructions = try day.parse(input)
        XCTAssertEqual(8, instructions.count)
        
        for key in instructions.keys.sorted() {
            print(key, try day.resolve(instructions[key]!, instructions: instructions))
        }
    }
}
