import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day22Tests: XCTestCase {
//    let input = Input("Day22.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day22()
        XCTAssertEqual(6256, day.part1(depth: 5913, target: Point(8,701)))
    }
    
    func test_part2() {
        let day = Day22()
        XCTAssertEqual(973, day.part2(depth: 5913, target: Point(8,701)))
    }
    
    func test_part2_example1() {
        let day = Day22()
        XCTAssertEqual(45, day.part2(depth: 510, target: Point(10,10)))
    }
    
    func test_part1_example1() {
        let day = Day22()
        XCTAssertEqual(114, day.part1(depth: 510, target: Point(10,10)))
    }
}
