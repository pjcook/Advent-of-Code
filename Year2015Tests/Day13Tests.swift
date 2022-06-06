import XCTest
import InputReader
import Year2015

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Year2015.bundle).lines
    let day = Day13()

    func test_part1() throws {
        XCTAssertEqual(664, try day.part1(input))
    }
    
    func test_part2() throws {
        XCTAssertEqual(640, try day.part2(input))
    }
    
    func test_example() throws {
        let input = """
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
""".lines
        XCTAssertEqual(330, try day.part1(input))
    }
}
