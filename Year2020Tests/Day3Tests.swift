import XCTest
import InputReader
import Year2020

class Day3Tests: XCTestCase {
    let input = Input("Day3.input", Year2020.bundle).lines

    func test_part1() {
        let traversal = Day3.Traversal(right: 3, down: 1)
        let day3 = Day3()
        let result = day3.howManyTrees(input: input, traversal: traversal)
        XCTAssertEqual(265, result)
    }
    
    func test_part2() {
        let traversals = [
            Day3.Traversal(right: 1, down: 1),
            Day3.Traversal(right: 3, down: 1),
            Day3.Traversal(right: 5, down: 1),
            Day3.Traversal(right: 7, down: 1),
            Day3.Traversal(right: 1, down: 2),

        ]
        let day3 = Day3()
        var sum = 1
        for traversal in traversals {
            let result = day3.howManyTrees(input: input, traversal: traversal)
            sum *= result
        }
        XCTAssertEqual(3154761400, sum)

    }
}
