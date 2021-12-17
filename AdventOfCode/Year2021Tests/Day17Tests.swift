import XCTest
import InputReader
import StandardLibraries
import Year2021

class Day17Tests: XCTestCase {
    
//    let input = Input("Day17.input", Year2021.bundle).input
    let day = Day17()
    // input x=169..206, y=-108..-68
    let targetArea = Day17.TargetArea(topLeft: Point(169,-68), bottomRight: Point(206, -108))
    let targetArea_stephen = Day17.TargetArea(topLeft: Point(70,-124), bottomRight: Point(96, -179))

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
    
    func test_stephen() {
        XCTAssertEqual(15931, day.part1(targetArea_stephen))
        XCTAssertEqual(2555, day.part2(targetArea_stephen))
    }
}
