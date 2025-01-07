import XCTest
import InputReader
import Year2015
import GLKit

class Day21Tests: XCTestCase {
    
    let input = Input("Day21.input", .module).lines
    let day = Day21()
    let boss = Day21.Character(name: "Boss", hitPoints: 103, damage: 9, armor: 2)
    
    // (Name, Cost, Damage, Armor),
    let weapons = [
        Day21.Item(("Dagger", 8, 4, 0)),
        Day21.Item(("Shortsword", 10, 5, 0)),
        Day21.Item(("Warhammer", 25, 6, 0)),
        Day21.Item(("Longsword", 40, 7, 0)),
        Day21.Item(("Greataxe", 74, 8, 0))
    ]
    
    let armor = [
        Day21.Item(("none", 0, 0, 0)),
        Day21.Item(("Leather", 13, 0, 1)),
        Day21.Item(("Chainmail", 31, 0, 2)),
        Day21.Item(("Splintmail", 53, 0, 3)),
        Day21.Item(("Bandedmail", 75, 0, 4)),
        Day21.Item(("Platemail", 102, 0, 5))
    ]
    
    let rings = [
        Day21.Item(("none", 0, 0, 0)),
        Day21.Item(("Damage +1", 25, 1, 0)),
        Day21.Item(("Damage +2", 50, 2, 0)),
        Day21.Item(("Damage +3", 100, 3, 0)),
        Day21.Item(("Defense +1", 20, 0, 1)),
        Day21.Item(("Defense +2", 40, 0, 2)),
        Day21.Item(("Defense +3", 80, 0, 3))
    ]
    
    func test_part1() {
        XCTAssertEqual(121, day.part1(boss: boss, weapons: weapons, armor: armor, rings: rings))
    }
    
    func test_part2() {
        XCTAssertEqual(201, day.part2(boss: boss, weapons: weapons, armor: armor, rings: rings))
    }
}
