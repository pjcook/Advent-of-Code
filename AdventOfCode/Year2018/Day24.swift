import Foundation

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var groups = parse(input)
        
        while multipleSystems(groups) {
            summary(groups)
            var selectionGroups = groups
            let sortedGroups = groups.sorted(by: { $0.unit.initiative > $1.unit.initiative }).sorted(by: { $0.effectivePower > $1.effectivePower })
            
            // targetting phase
            for group in sortedGroups {
                selectionGroups = group.targetSelection(selectionGroups)
                if selectionGroups.isEmpty {
                    break
                }
            }
            print()
            // attacking phase
            for group in sortedGroups.sorted(by: { $0.unit.initiative > $1.unit.initiative }) {
                group.attack()
            }
            print()
            // Clear out the dead
            groups = sortedGroups.filter({ $0.numberOfUnits > 0 })
            print()
        }
        
        return groups.reduce(0, { $0 + $1.numberOfUnits })
    }
    
    func summary(_ groups: [Group]) {
        print("Immune System:")
        for group in groups.filter({ $0.type == .immune }) {
            print(group.id, "contains", group.numberOfUnits, "units")
        }
        
        print("Infection:")
        for group in groups.filter({ $0.type == .infection }) {
            print(group.id, "contains", group.numberOfUnits, "units")
        }
        
        print()
    }
    
    func multipleSystems(_ groups: [Group]) -> Bool {
        guard groups.count > 1 else { return false }
        var immune = false
        var infection = false
        
        for group in groups {
            switch group.type {
            case .immune: immune = true
            case .infection: infection = true
            }
            if immune && infection {
                return true
            }
        }
        
        return false
    }
}

extension Day24 {
    func parse(_ input: [String]) -> [Group] {
        var input = input
        
        var groups = [Group]()
        var immuneCount = 0
        var infectionCount = 0
        
        outerloop: while !input.isEmpty {
            let type = SystemType(rawValue: input.removeFirst())!
            
            while !input.isEmpty {
                let line = input.removeFirst()
                guard !line.isEmpty else { continue outerloop }
                var id = "Group "
                switch type {
                case .immune:
                    immuneCount += 1
                    id += String(immuneCount)
                    
                case .infection:
                    infectionCount += 1
                    id += String(infectionCount)
                }
                groups.append(Group(line, type, id))
            }
        }
        
        return groups
    }
}

enum SystemType: String {
    case immune = "Immune System:"
    case infection = "Infection:"
}

class Group {
    let id: String
    let type: SystemType
    let unit: Unit
    var numberOfUnits: Int
    var target: Group?
    
    var effectivePower: Int {
        numberOfUnits * unit.damage
    }
    
    init(_ input: String, _ type: SystemType, _ id: String) {
        self.id = id
        self.type = type
        var components = input.components(separatedBy: " units each with ")
        numberOfUnits = Int(components[0])!
        components = components[1].components(separatedBy: " hit points ")
        
        let hitPoints = Int(components[0])!
        components = components[1].components(separatedBy: " with an attack that does ")

        var remainder = ""
        var weakness: Set<Unit.AttackType> = []
        var immunities: Set<Unit.AttackType> = []
        if components[0].hasPrefix("(") {
            var info = components[0]
            _ = info.removeFirst()
            _ = info.removeLast()
            let info2 = info.components(separatedBy: "; ")
            
            for info in info2 {
                var info = info
                if info.hasPrefix("weak to ") {
                    info = info.replacingOccurrences(of: "weak to ", with: "")
                    weakness = Set(info.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                } else {
                    info = info.replacingOccurrences(of: "immune to ", with: "")
                    immunities = Set(info.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                }
            }
            
            remainder = components[1]
        } else {
            remainder = components[0].replacingOccurrences(of: "with an attack that does ", with: "")
        }
        
        components = remainder.components(separatedBy: " ")
        let damage = Int(components.first!)!
        let attackType = components[1]
        let initiative = Int(components.last!)!
        unit = Unit(hitPoints: hitPoints, attackType: attackType, damage: damage, initiative: initiative, weakness: weakness, immunities: immunities)
    }
    
    func targetSelection(_ groups: [Group]) -> [Group] {
        target = nil
        guard !groups.isEmpty else { return [] }
        let options = groups
            .filter({ $0.type != type && !$0.unit.immunities.contains(unit.attackType) })
            .sorted(by: { $0.calculateAttackDamage(self) > $1.calculateAttackDamage(self) })
        guard !options.isEmpty else { return groups }
        target = options.first
        for option in options {
            print(type == .immune ? "Immune System" : "Infection", id, "would deal defending", option.id, option.calculateAttackDamage(self), "damage")
        }
        var groups = groups
        groups.remove(at: groups.firstIndex(where: { $0.id == target!.id && $0.type == target!.type })!)
        return groups
    }
    
    func attack() {
        guard numberOfUnits > 0, let target = target else { return }
        let attackValue = target.targetValue(self)
        print(type == .immune ? "Immune System" : "Infection", id, "attacks defending", target.id, "killing", attackValue, "units")
        target.numberOfUnits -= attackValue
    }
    
    func calculateAttackDamage(_ group: Group) -> Int {
        let attackMultiplier = unit.attackValue(group.unit.attackType)
        return group.effectivePower * attackMultiplier
    }
    
    func targetValue(_ group: Group) -> Int {
        let damage = calculateAttackDamage(group)
        return Int(floor(Double(damage / unit.hitPoints)))
    }
}

struct Unit {
    typealias AttackType = String
    
    let hitPoints: Int
    let attackType: AttackType
    let damage: Int
    let initiative: Int
    let weakness: Set<AttackType>
    let immunities: Set<AttackType>
    
    func attackValue(_ attackType: AttackType) -> Int {
        weakness.contains(attackType) ? 2 : 1
    }
}
