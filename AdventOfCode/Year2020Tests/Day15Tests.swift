import XCTest
import InputReader
import Year2020

class Day15Tests: XCTestCase {
    let input = [6,19,0,5,7,13,1]
    let day = Day15()

    func test_part1() {
        measure {
        XCTAssertEqual(468, day.solve(input))
        }
    }
    
    func test_part2() {
        measure {
        XCTAssertEqual(1801753, day.solve(input, maxTime: 30000000))
        }
    }
    
    func test_part1_example1() {
        let input = [0,3,6]
        XCTAssertEqual(436, day.solve(input))
    }
    
    func test_part1_example2() {
        let input = [1,3,2]
        XCTAssertEqual(1, day.solve(input))
    }
    
    func test_part1_example3() {
        let input = [2,1,3]
        XCTAssertEqual(10, day.solve(input))
    }
    
    func test_part1_example4() {
        let input = [1,2,3]
        XCTAssertEqual(27, day.solve(input))
    }
    
    func test_part1_example5() {
        let input = [2,3,1]
        XCTAssertEqual(78, day.solve(input))
    }
    
    func test_part1_example6() {
        let input = [3,2,1]
        XCTAssertEqual(438, day.solve(input))
    }
    
    func test_part1_example7() {
        let input = [3,1,2]
        XCTAssertEqual(1836, day.solve(input))
    }
}
