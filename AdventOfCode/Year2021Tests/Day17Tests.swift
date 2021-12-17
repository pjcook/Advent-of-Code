import XCTest
import InputReader
import StandardLibraries
import Year2021

class Day17Tests: XCTestCase {
    
//    let input = Input("Day17.input", Year2021.bundle).input
    let day = Day17()
    // input x=169..206, y=-108..-68
    let targetArea = Day17.TargetArea(topLeft: Point(169,-68), bottomRight: Point(206, -108))

    func test_part1() {
//        measure {
        XCTAssertEqual(5778, day.part1(targetArea))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2576, day.part2(targetArea))
//        }
    }
}
