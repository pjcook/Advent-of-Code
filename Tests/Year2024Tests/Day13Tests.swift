import XCTest
import InputReader
import Year2024

class Day13Tests: XCTestCase {
    
    let input = Input("Day13.input", Bundle.module).lines
    let day = Day13()

    func test_part1() {
//        measure {
        XCTAssertEqual(31552, day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
""".lines
        XCTAssertEqual(480, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(95273925552482, day.part2b(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
""".lines
        XCTAssertEqual(875318608908, day.part2b(input))
    }
}

