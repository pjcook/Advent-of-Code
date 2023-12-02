import XCTest
import InputReader
import Year2023

class Day2Tests: XCTestCase {
    
    let input = Input("Day2.input", Bundle.module).lines
    let day = Day2()

    func test_part1() {
//        measure {
        XCTAssertEqual(2265, day.part1(input, limits: Day2.CubeGameLimits(red: 12, green: 13, blue: 14)))
//        }
    }
    
    func test_part1_example() {
        let input = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
""".lines
        XCTAssertEqual(8, day.part1(input, limits: Day2.CubeGameLimits(red: 12, green: 13, blue: 14)))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(64097, day.part2(input))
//        }
    }
}
