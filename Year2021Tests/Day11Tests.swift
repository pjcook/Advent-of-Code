import XCTest
import InputReader
import Year2021

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Year2021.bundle).lines
    let day = Day11()

    func test_part1() {
//        measure {
        XCTAssertEqual(1661, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(334, day.part2(input))
//        }
    }
    
    func test_example1() {
        let input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
""".lines
        
        XCTAssertEqual(1656, day.part1(input))
    }
    
    func test_example2() {
        let input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
""".lines
        
        XCTAssertEqual(195, day.part2(input))
    }
}
