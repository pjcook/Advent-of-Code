import XCTest
import InputReader
import Year2021

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Year2021.bundle).delimited(",", cast: { Int($0)! })
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual(340056, day.part1(input))
//        }
    }
    
    func test_part1b() {
//        measure {
        XCTAssertEqual(340056, day.part1b(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(96592275, day.part2(input))
//        }
    }
    
    func test_part2b() {
//        measure {
        XCTAssertEqual(96592275, day.part2b(input))
//        }
    }
    
    func test_example() {
        let input = [16,1,2,0,4,2,7,1,2,14]
        XCTAssertEqual(37, day.part1(input))
    }
}
