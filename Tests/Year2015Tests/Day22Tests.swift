import XCTest
import InputReader
import Year2015

class Day22Tests: XCTestCase {
    
    let input = Input("Day22.input", .module).lines
    let day = Day22()
    var boss = Day22.Character(name: "Boss", hitPoints: 55, damage: 8, armor: 0, mana: 0)
    var player = Day22.Character(name: "Player", hitPoints: 50, damage: 0, armor: 0, mana: 500)

    func test_part1() {
        XCTAssertEqual(953, day.part1(player: player, boss: boss))
    }
    
//    func test_part1b() {
//        // EXPECT: 1824 for HP: 71 DMG: 10
//        // EXPECT:  953 for HP: 55 DMG:  8
//        XCTAssertEqual(953, day.part1b())
//    }
    
    func test_part1_example() {
        var boss = Day22.Character(name: "Boss", hitPoints: 14, damage: 8, armor: 0, mana: 0)
        var player = Day22.Character(name: "Player", hitPoints: 10, damage: 0, armor: 0, mana: 250)
        let spells = [
            Day22.MagicItem.recharge, // 6
            Day22.MagicItem.shield, // 5
            Day22.MagicItem.drain, // 6
            Day22.MagicItem.poison, // 5
            Day22.MagicItem.magicMissile, // 6
        ]
        XCTAssertEqual(641, day.fight(player: &player, boss: &boss, spells: spells))
    }
    
    func test_part1_example2() {
        let spells = [
            Day22.MagicItem.recharge,
            Day22.MagicItem.poison,
            Day22.MagicItem.shield,
            Day22.MagicItem.magicMissile,
            Day22.MagicItem.magicMissile,
            Day22.MagicItem.poison,
            Day22.MagicItem.magicMissile,
            Day22.MagicItem.magicMissile,
            Day22.MagicItem.magicMissile,
        ]

        XCTAssertEqual(953, day.fight(player: &player, boss: &boss, spells: spells))
    }
    
    func test_part2() {
        XCTAssertEqual(1289, day.part1(player: player, boss: boss, isPart2: true))
    }
}
