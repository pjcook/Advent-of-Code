import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day15Tests: XCTestCase {
    let input = Input("Day15.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day15()
        XCTAssertEqual(220480, day.part1(input))
    }
    
    func test_part2() {
        let day = Day15()
        XCTAssertEqual(53576, day.part2(input))
    }
    
    func test_part1_example1() {
        let day = Day15()
        let input = Input("Day15_example1.input", Year2018.bundle).lines
        XCTAssertEqual(27730, day.part1(input))
    }
    
    func test_part1_example2() {
        let day = Day15()
        let input = Input("Day15_example2.input", Year2018.bundle).lines
        XCTAssertEqual(36334, day.part1(input))
    }
    
    func test_part1_example3() {
        let day = Day15()
        let input = Input("Day15_example3.input", Year2018.bundle).lines
        XCTAssertEqual(39514, day.part1(input))
    }
    
    func test_part1_example4() {
        let day = Day15()
        let input = Input("Day15_example4.input", Year2018.bundle).lines
        XCTAssertEqual(27755, day.part1(input))
    }
    
    func test_part1_example5() {
        let day = Day15()
        let input = Input("Day15_example5.input", Year2018.bundle).lines
        XCTAssertEqual(28944, day.part1(input))
    }
    
    func test_part1_example6() {
        let day = Day15()
        let input = Input("Day15_example6.input", Year2018.bundle).lines
        XCTAssertEqual(18740, day.part1(input))
    }
}
