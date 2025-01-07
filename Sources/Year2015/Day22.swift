import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
        
    enum GameElements {
            static let magicMissileCost = 53
            static let magicMissileDamage = 4
            static let drainCost = 73
            static let drainDamage = 2
            static let drainHeal = 2
            static let shieldCost = 113
            static let shieldTimer = 6
            static let shieldArmor  = 7
            static let poisonCost = 173
            static let poisonTimer = 6
            static let poisonDamage = 3
            static let rechargeCost = 229
            static let rechargeTimer = 5
            static let rechargeMana = 101
    }
    
    public struct GameState: Hashable {
        public var bossHitPoints = 55
        public let bossDamage = 8
        public var playerHitPoints = 50
        public var playerMana = 500
        public var shieldTimer = 0
        public var poisonTimer = 0
        public var rechargeTimer = 0
        public var manaSpent = 0
        
        public init() {}
        
        public init(copying state: GameState) {
            self.bossHitPoints = state.bossHitPoints
            self.playerHitPoints = state.playerHitPoints
            self.playerMana = state.playerMana
            self.shieldTimer = state.shieldTimer
            self.poisonTimer = state.poisonTimer
            self.rechargeTimer = state.rechargeTimer
            self.manaSpent = state.manaSpent
        }
        
        public func copy() -> GameState {
            GameState(copying: self)
        }
    }
    
    public func part1b() -> Int {
        let queue = PriorityQueue<GameState>()
        var seen = Set<GameState>()
        queue.enqueue(GameState(), priority: 0)
        var minManaSpent = Int.max
        var i = 0
        while var state = queue.dequeue() {
            guard !seen.contains(state) else { continue }
            seen.insert(state)
            i += 1
            if i % 100000 == 0 { print(i, minManaSpent, queue.queuedItems.count) }
            guard state.manaSpent < minManaSpent else { continue }
            if applyEffects(&state, &minManaSpent) {
                castMagicMissile(state, minManaSpent: &minManaSpent, queue: queue)
                castDrain(state, minManaSpent: &minManaSpent, queue: queue)
                castShield(state, minManaSpent: &minManaSpent, queue: queue)
                castPoison(state, minManaSpent: &minManaSpent, queue: queue)
                castRecharge(state, minManaSpent: &minManaSpent, queue: queue)
            }
        }
        
        return minManaSpent
    }
    
    func gameOver(_ state: GameState, _ minManaSpent: inout Int) -> Bool {
        let died = state.playerHitPoints < 1
        let killed = state.bossHitPoints < 1
        if killed && !died && state.manaSpent < minManaSpent {
            minManaSpent = state.manaSpent
            print("smaller", minManaSpent)
        }
        return died || killed
    }
    
    func applyEffects(_ state: inout GameState, _ minManaSpent: inout Int) -> Bool {
        if state.poisonTimer > 0 {
            state.poisonTimer -= 1
            state.bossHitPoints -= GameElements.poisonDamage
            if gameOver(state, &minManaSpent) {
                return false
            }
        }
        if state.shieldTimer > 0 {
            state.shieldTimer -= 1
        }
        if state.rechargeTimer > 0 {
            state.rechargeTimer -= 1
            state.playerMana += GameElements.rechargeMana
        }
        return true
    }
    
    func castMagicMissile(_ state: GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if state.playerMana > GameElements.magicMissileCost {
            var nextState = state.copy()
            nextState.manaSpent += GameElements.magicMissileCost
            nextState.playerMana -= GameElements.magicMissileCost
            nextState.bossHitPoints -= GameElements.magicMissileDamage
            bossTurn(&nextState, minManaSpent: &minManaSpent, queue: queue)
        }
    }
    
    func castDrain(_ state: GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if state.playerMana > GameElements.drainCost {
            var nextState = state.copy()
            nextState.manaSpent += GameElements.drainCost
            nextState.playerMana -= GameElements.drainCost
            nextState.bossHitPoints -= GameElements.drainDamage
            nextState.playerHitPoints += GameElements.drainHeal
            bossTurn(&nextState, minManaSpent: &minManaSpent, queue: queue)
        }
    }
    
    func castShield(_ state: GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if state.playerMana > GameElements.shieldCost, state.shieldTimer == 0 {
            var nextState = state.copy()
            nextState.manaSpent += GameElements.shieldCost
            nextState.playerMana -= GameElements.shieldCost
            nextState.shieldTimer += GameElements.shieldTimer
            if !gameOver(nextState, &minManaSpent) {
                bossTurn(&nextState, minManaSpent: &minManaSpent, queue: queue)
            }
        }
    }
    
    func castPoison(_ state: GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if state.playerMana > GameElements.poisonCost, state.poisonTimer == 0 {
            var nextState = state.copy()
            nextState.manaSpent += GameElements.poisonCost
            nextState.playerMana -= GameElements.poisonCost
            nextState.poisonTimer += GameElements.poisonTimer
            if !gameOver(nextState, &minManaSpent) {
                bossTurn(&nextState, minManaSpent: &minManaSpent, queue: queue)
            }
        }
    }
    
    func castRecharge(_ state: GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if state.playerMana > GameElements.rechargeCost, state.rechargeTimer == 0 {
            var nextState = state.copy()
            nextState.manaSpent += GameElements.rechargeCost
            nextState.playerMana -= GameElements.rechargeCost
            nextState.rechargeTimer += GameElements.rechargeTimer
            if !gameOver(nextState, &minManaSpent) {
                bossTurn(&nextState, minManaSpent: &minManaSpent, queue: queue)
            }
        }
    }
    
    func bossTurn(_ state: inout GameState, minManaSpent: inout Int, queue: PriorityQueue<GameState>) {
        if applyEffects(&state, &minManaSpent) {
            let armor = state.shieldTimer > 0 ? GameElements.shieldArmor : 0
            let damage = max(1, state.bossDamage - armor)
            state.playerHitPoints -= damage
            if !gameOver(state, &minManaSpent) {
                queue.enqueue(state, priority: state.manaSpent)
            }
        }
    }
    
    public struct MagicItem: Hashable {
        public let name: String
        public let cost: Int
        public let damage: Int
        public let armor: Int
        public let healing: Int
        public let duration: Int
        public let mana: Int
        
        public static let magicMissile = MagicItem(name: "Magic missile", cost: 53, damage: 4, armor: 0, healing: 0, duration: 0, mana: 0)
        public static let drain = MagicItem(name: "Drain", cost: 73, damage: 2, armor: 0, healing: 2, duration: 0, mana: 0)
        public static let shield = MagicItem(name: "Shield", cost: 113, damage: 0, armor: 7, healing: 0, duration: 6, mana: 0)
        public static let poison = MagicItem(name: "Poison", cost: 173, damage: 3, armor: 0, healing: 0, duration: 6, mana: 0)
        public static let recharge = MagicItem(name: "Recharge", cost: 229, damage: 0, armor: 0, healing: 0, duration: 5, mana: 101)
        public static let allSpells = Set([magicMissile, drain, shield, poison, recharge])
    }

    public struct Character: Hashable {
        public let name: String
        public var hitPoints: Int
        public var damage: Int
        public var armor: Int
        public var mana: Int
        public var activeSpells = [MagicItem: Int]()
        public var isAlive: Bool { hitPoints > 0 }
        public var isDead: Bool { !isAlive }
        public var history: [MagicItem] = []
        
        public init(name: String, hitPoints: Int, damage: Int, armor: Int, mana: Int, activeSpells: [MagicItem: Int] = [:], history: [MagicItem] = []) {
            self.name = name
            self.hitPoints = hitPoints
            self.damage = damage
            self.armor = armor
            self.mana = mana
            self.activeSpells = activeSpells
            self.history = history
        }
        
        @discardableResult public mutating func cast(spell: MagicItem, target: inout Character) -> Bool {
            guard mana >= spell.cost && !activeSpells.keys.contains(spell) else { return false }
            history.append(spell)
            mana -= spell.cost
            if spell.duration == 0 {
                target.hitPoints -= spell.damage
                hitPoints += spell.healing
            } else {
                activeSpells[spell] = spell.duration
                armor += spell.armor
            }
            return true
        }
        
        public mutating func turnHardMode() {
            hitPoints -= 1
        }
        
        public mutating func takeTurn(target: inout Character) {
            for (spell, remainingTurns) in activeSpells {
                hitPoints += spell.healing
                mana += spell.mana
                target.hitPoints -= spell.damage
                if remainingTurns-1 == 0 {
                    activeSpells.removeValue(forKey: spell)
                    armor -= spell.armor
                } else {
                    activeSpells[spell] = remainingTurns-1
                }
            }
        }
        
        public func attack(target: inout Character) {
            let damage = damage - target.armor
            target.hitPoints -= max(0, damage)
        }

        public func clone() -> Character {
            Character(name: name, hitPoints: hitPoints, damage: damage, armor: armor, mana: mana, activeSpells: activeSpells, history: history)
        }
        
        public func possibleSpellOptions(for spells: Set<MagicItem> = MagicItem.allSpells) -> Set<MagicItem> {
            spells.subtracting(Set(activeSpells.keys)).filter {
                $0.cost <= mana
            }
        }
    }
    
    struct Match: Hashable {
        let player: Character
        let boss: Character
        let costSoFar: Int
    }
    
    public func part1(player: Character, boss: Character, isPart2: Bool = false) -> Int {
        var seen = Set<Match>()
        var minCost = Int.max
        let queue = PriorityQueue<Match>()
        queue.enqueue(Match(player: player, boss: boss, costSoFar: 0), priority: 0)
        
        while let match = queue.dequeue() {
            if seen.contains(match) {
                continue
            }
            seen.insert(match)
            guard match.costSoFar < minCost else { continue }
            var p = match.player.clone()
            if isPart2 {
                p.turnHardMode()
                if match.player.isDead {
                    continue
                }
            }
            var b = match.boss.clone()
            p.takeTurn(target: &b)

            for spell in p.possibleSpellOptions() {
                var p2 = p.clone()
                var b2 = b.clone()
                var cost = match.costSoFar
                if p2.cast(spell: spell, target: &b2) {
                    cost += spell.cost
                }
                p2.takeTurn(target: &b2)
                if b2.isAlive {
                    b2.attack(target: &p2)
                }
                
                if p2.isAlive && b2.isDead {
                    if minCost != Int.max, cost <= minCost {
                        return cost
                    }
                    minCost = min(minCost, cost)
//                    print("\n", p2.history, "\n")
                } else if p2.isAlive && b2.isAlive {
                    queue.enqueue(Match(player: p2, boss: b2, costSoFar: cost), priority: cost)
                }
            }
        }
        
        return minCost
    }
}

extension Day22 {
    public func fight(player: inout Character, boss: inout Character, spells: [MagicItem]) -> Int {
        var cost = 0
        var spellIndex = 0
        log(player: player, boss: boss)
        
        while player.isAlive && boss.isAlive {
            player.takeTurn(target: &boss)
            let spell = spells[spellIndex]
            log(player: player, boss: boss, isPlayersTurn: true)
            if player.cast(spell: spell, target: &boss) {
                cost += spell.cost
                log(spell: spell, player: player, boss: boss)
            }
            player.takeTurn(target: &boss)
            if boss.isAlive {
                boss.attack(target: &player)
            }
            log(player: player, boss: boss, isPlayersTurn: false)

            spellIndex += 1
            spellIndex %= spells.count
        }
        
        print()
        if player.isDead {
            print("Player died", cost, "\n")
            return -1
        }
        print("Player won", cost, "\n")
        return cost
    }
    
    func log(player: Character, boss: Character) {
        print("SUMMARY:", player.name, player.hitPoints, player.mana, player.activeSpells.map({ "\($0.key.name):\($0.value)" }).joined(separator: ","), boss.name, boss.hitPoints)
        print()
    }
    
    func log(spell: MagicItem, player: Character, boss: Character) {
        print("- CAST :", spell.name, player.name, player.hitPoints, player.mana, player.activeSpells.map({ "\($0.key.name):\($0.value)" }).joined(separator: ","), boss.name, boss.hitPoints)
    }
    
    func log(player: Character, boss: Character, isPlayersTurn: Bool) {
        print(isPlayersTurn ? "PLAYER :" : "BOSS   :", player.name, player.hitPoints, player.mana, player.activeSpells.map({ "\($0.key.name):\($0.value)" }).joined(separator: ","), boss.name, boss.hitPoints)
    }
    
    public func fight2(player: inout Character, boss: inout Character, spells: [MagicItem]) -> Int {
        var cost = 0
        var spellIndex = 0
        log(player: player, boss: boss)
        
        while player.isAlive && boss.isAlive {
            player.takeTurn(target: &boss)
            player.turnHardMode()
            if player.isDead {
                continue
            }
            let spell = spells[spellIndex]
            log(player: player, boss: boss, isPlayersTurn: true)
            if player.cast(spell: spell, target: &boss) {
                cost += spell.cost
                log(spell: spell, player: player, boss: boss)
            }
            player.takeTurn(target: &boss)
            if boss.isAlive {
                boss.attack(target: &player)
            }
            log(player: player, boss: boss, isPlayersTurn: false)

            spellIndex += 1
            spellIndex %= spells.count
        }
        
        print()
        if player.isDead {
            print("Player died", cost, "\n")
            return -1
        }
        print("Player won", cost, "\n")
        return cost
    }
}
