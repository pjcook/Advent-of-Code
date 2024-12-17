import XCTest
import InputReader
import StandardLibraries
import Year2024

class Day17Tests: XCTestCase {
    
    let day = Day17()

    func test_part1() {
        let computer = Day17.Computer(a: 64012472, b: 0, c: 0, program: [2,4,1,7,7,5,0,3,1,7,4,1,5,5,3,0])
//        measure {
        XCTAssertEqual("1,0,2,0,5,7,2,1,3", day.part1(computer))
//        }
    }
    
    func test_part1_example() {
        let computer = Day17.Computer(a: 729, b: 0, c: 0, program: [0,1,5,4,3,0])
        XCTAssertEqual("4,6,3,5,6,3,5,2,1,0", day.part1(computer))
    }
    
    func test_part2() {
        let computer = Day17.Computer(a: 64012472, b: 0, c: 0, program: [2,4,1,7,7,5,0,3,1,7,4,1,5,5,3,0])
//        measure { 
        XCTAssertEqual(265652340990875, day.part2(computer))
//        }
    }
    
    func test_part2_example() {
        let computer = Day17.Computer(a: 729, b: 0, c: 0, program: [0,3,5,4,3,0])
        XCTAssertEqual(117440, day.part2(computer))
    }
}
