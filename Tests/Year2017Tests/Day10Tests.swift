import XCTest
import InputReader
import Year2017

class Day10Tests: XCTestCase {
    
    let input = Input("Day10.input", Bundle.module).input
    let day = Day10()

    func test_part1() {
//        measure {
        XCTAssertEqual(38415, day.part1(input.split(separator: ",").map(String.init).compactMap(Int.init), Array(0...255)))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual(12, day.part1([3,4,1,5], Array(0...4)))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("9de8846431eef262be78f590e39a4848", day.part2(input))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual("3efbe78a8d82f29979031a4aa0b16a9d", day.part2("1,2,3"))
    }
}
