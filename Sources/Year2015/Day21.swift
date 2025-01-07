import Foundation
import StandardLibraries

public struct Day21 {
    public struct Item: Equatable {
        public let name: String
        public let cost: Int
        public let damage: Int
        public let armor: Int
        
        public init(_ input: (String, Int, Int, Int)) {
            name = input.0
            cost = input.1
            damage = input.2
            armor = input.3
        }
        
        public static func == (lhs: Day21.Item, rhs: Day21.Item) -> Bool {
            lhs.name == rhs.name
        }
    }
    
    public class Character: Equatable {
        public let name: String
        public var hitPoints: Int
        public let damage: Int
        public let armor: Int
        
        public init(name: String, hitPoints: Int, damage: Int, armor: Int) {
            self.name = name
            self.hitPoints = hitPoints
            self.damage = damage
            self.armor = armor
        }
        
        public func attack(target: Character) {
            let damage = damage - target.armor
            target.hitPoints -= max(0, damage)
        }
        
        public static func == (lhs: Character, rhs: Character) -> Bool {
            lhs.name == rhs.name
        }
        
        public func clone() -> Character {
            Character(name: name, hitPoints: hitPoints, damage: damage, armor: armor)
        }
    }
    
    public init() {}
    
    public func part1(boss: Character, weapons: [Item], armor: [Item], rings: [Item]) -> Int {
        var minCost = Int.max
        for weapon in weapons {
            for a in armor {
                for ring in rings {
                    let damage = weapon.damage + a.damage + ring.damage
                    let playerArmor = weapon.armor + a.armor + ring.armor
                    let cost = weapon.cost + a.cost + ring.cost
                    let player = Day21.Character(name: "Player", hitPoints: 100, damage: damage, armor: playerArmor)
                    if fight(player: player, boss: boss.clone()) == player {
                        minCost = min(cost, minCost)
                    }
                }
            }
        }
        return minCost
    }
    
    public func part2(boss: Character, weapons: [Item], armor: [Item], rings: [Item]) -> Int {
        var maximumLoser = 0
        for weapon in weapons {
            for a in armor {
                for ring in rings {
                    for ring2 in rings where ring2 != ring || ring2.name == "none" {
                        let damage = weapon.damage + a.damage + ring.damage + ring2.damage
                        let playerArmor = weapon.armor + a.armor + ring.armor + ring2.armor
                        let cost = weapon.cost + a.cost + ring.cost + ring2.cost
                        let player = Day21.Character(name: "Player", hitPoints: 100, damage: damage, armor: playerArmor)
                        if fight(player: player, boss: boss.clone()) == boss {
                            print(cost, maximumLoser)
                            maximumLoser = max(cost, maximumLoser)
                        }
                    }
                }
            }
        }
        return maximumLoser
    }
}

extension Day21 {
    func fight(player: Character, boss: Character) -> Character {
        var isPlayerTurn = true
        while player.hitPoints > 0 && boss.hitPoints > 0 {
            isPlayerTurn ? player.attack(target: boss) : boss.attack(target: player)
            isPlayerTurn.toggle()
        }
        return player.hitPoints > 0 ? player : boss
    }
}
