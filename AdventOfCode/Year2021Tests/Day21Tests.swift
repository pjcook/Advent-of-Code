import XCTest
import InputReader
import Year2021

class Day21Tests: XCTestCase {
    
//    let input = Input("Day21.input", Year2021.bundle).lines
    let day = Day21()

    func test_part1() {
        let game = Day21.Board(dice: Day21.DeterministicDice(100), player1StartingAt: 6, player2StartingAt: 7)
        XCTAssertEqual(921585, day.part1(game))
    }
    
    func test_part1_condensed() {
        XCTAssertEqual(921585, day.part1_condensed(Day21.Game(6,7)))
    }
    
    func test_part1_jonathanPoulson() {
        XCTAssertEqual(921585, day.part1_jonathanPoulson(Day21.Game(6,7)))
    }
    
    func test_part2() {
        XCTAssertEqual(911090395997650, day.part2_jonathanPoulson(Day21.Game(6,7)))
    }
    
    func test_part2_jonathanPoulson() {
        XCTAssertEqual(444356092776315, day.part2_jonathanPoulson(Day21.Game(4,8)))
    }
    
    func test_example() {
        let game = Day21.Board(dice: Day21.DeterministicDice(100), player1StartingAt: 4, player2StartingAt: 8)
        
        XCTAssertEqual(739785, day.part1(game))
    }
}
