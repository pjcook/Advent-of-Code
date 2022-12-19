import XCTest
import InputReader
import Year2022

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", Bundle.module).input
    let day = Day19()

    func test_part1() {
//        measure {
        XCTAssertEqual(1962, day.part1(input))
        // 1554 too low
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(88160, day.part2(input))
//        }
    }
}

extension Day19Tests {
    func test_part1_example() {
        let input = """
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
"""
        XCTAssertEqual(33, day.part1(input))
    }
    
    func test_part1_parse() {
        let input = """
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
"""
        let blueprints = day.parse(input)
        XCTAssertEqual(2, blueprints.count)
        XCTAssertEqual(1, blueprints[0].id)
        XCTAssertEqual(4, blueprints[0].oreCost)
        XCTAssertEqual(2, blueprints[0].clayRobotOreCost)
        XCTAssertEqual(3, blueprints[0].obsidianRobotCostOre)
        XCTAssertEqual(14, blueprints[0].obsidianRobotCostClay)
        XCTAssertEqual(2, blueprints[0].geodeRobotCostOre)
        XCTAssertEqual(7, blueprints[0].geodeRobotCostObsidian)
    }
}
