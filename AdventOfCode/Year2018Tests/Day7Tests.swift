import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day7Tests: XCTestCase {
    let input = Input("Day7.input", Year2018.bundle)

    func test_part1() throws {
        let day = Day7()
        let result = day.part1(day.graph(try! day.parse(input.lines)))
        XCTAssertEqual("BFKEGNOVATIHXYZRMCJDLSUPWQ", result)
    }
    
    func test_part2() throws {
        let day = Day7()
        let result = day.part2(day.graph(try! day.parse(input.lines), addTime: true))
        XCTAssertEqual(1020, result)
    }
    
    func test_part1_example() throws {
        let input = """
        Step C must be finished before step A can begin.
        Step C must be finished before step F can begin.
        Step A must be finished before step B can begin.
        Step A must be finished before step D can begin.
        Step B must be finished before step E can begin.
        Step D must be finished before step E can begin.
        Step F must be finished before step E can begin.
        """
        let day = Day7()
        let result = day.part1(day.graph(try day.parse(input.lines)))
        XCTAssertEqual("CABDFE", result)
    }
    
    func test_part2_example() throws {
        let input = """
        Step C must be finished before step A can begin.
        Step C must be finished before step F can begin.
        Step A must be finished before step B can begin.
        Step A must be finished before step D can begin.
        Step B must be finished before step E can begin.
        Step D must be finished before step E can begin.
        Step F must be finished before step E can begin.
        """
        let day = Day7()
        let result = day.part2(day.graph(try day.parse(input.lines), addTime: true), numberOfWorkers: 2, stepDuration: 0)
        XCTAssertEqual(15, result)
    }
    
    func test_input_regex() throws {
        let input = "Step F must be finished before step N can begin."
        let day = Day7()
        let match = try day.regex.match(input)
        XCTAssertNotNil(match)
        XCTAssertEqual("F", try match.string(at: 0))
        XCTAssertEqual("N", try match.string(at: 1))
    }
}
