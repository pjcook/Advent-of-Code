import XCTest
import InputReader
import StandardLibraries
import Year2018

class Day24Tests: XCTestCase {
    let input = Input("Day24.input", Year2018.bundle).lines
    
    func test_part1() {
        let day = Day24()
        XCTAssertEqual(26743, day.part1(input))
    }
    
    func test_part1_example() {
        let day = Day24()
        let input = """
        Immune System:
        17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
        989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

        Infection:
        801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
        4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
        """.lines
        
        XCTAssertEqual(5216, day.part1(input))
    }
}
