import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day21Tests: XCTestCase {
    let input = Input("Day21.input", .module).lines

//    func test_part1() {
//        let day = Day21()
//        XCTAssertEqual(11285115, day.part1(input))
//    }
    
//    func test_solve() {
//        let day = Day21()
//        let results = day.solve(input)
//        let part1 = results.first
//        let part2 = results.last
//        XCTAssertEqual(11285115, part1)
//        XCTAssertEqual(2947113, part2)
//    }
    
    func test_solve() {
        let day = Day21()
        let results = day.solve()
        let part1 = results.first
        let part2 = results.last
        XCTAssertEqual(11285115, part1)
        XCTAssertEqual(2947113, part2)
    }
}
