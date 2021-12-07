import Foundation
import StandardLibraries

public struct Day21 {
    public struct Item {
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
    }
    
    public class Character {
        public var hitPoints: Int
        public let damage: Int
        public let armor: Int
        
        public init(hitPoints: Int, damage: Int, armor: Int) {
            self.hitPoints = hitPoints
            self.damage = damage
            self.armor = armor
        }
    }
    
    public init() {}
    
    public func part1(boss: Character, weapons: [Item], armor: [Item], rings: [Item]) -> Int {
        return 0
    }
    
    public func part2(_ input: [String]) -> Int {
        return 0
    }
}
