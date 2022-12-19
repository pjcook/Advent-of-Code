//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import InputReader

public struct Day19 {
    public init() {}
    
    public func part1(_ input: String, minutes: Int = 24) -> Int {
        let blueprints = parse(input)
        var total = 0
        for blueprint in blueprints {
            let result = run(blueprint: blueprint, minutes: minutes)
            print("++ Total \(result) ++")
            total += result * blueprint.id
        }

        return total
    }
    
    public func part2(_ input: String, minutes: Int = 32) -> Int {
        let blueprints = parse(input)
        var total = 1
        for blueprint in blueprints.prefix(3) {
            let result = run(blueprint: blueprint, minutes: minutes)
            print("++ Total \(result) ++")
            total *= result
        }

        return total
    }
}

extension Day19 {
    public struct State: Hashable {
        public let ore: Int
        public let clay: Int
        public let obsidian: Int
        public let geode: Int
        public let oreRobots: Int
        public let clayRobots: Int
        public let obsidianRobots: Int
        public let geodeRobots: Int
        public let timeRemaining: Int
        
        public init(_ ore: Int, _ clay: Int, _ obsidian: Int, _ geode: Int, _ oreRobots: Int, _ clayRobots: Int, _ obsidianRobots: Int, _ geodeRobots: Int, _ timeRemaining: Int) {
            self.ore = ore
            self.clay = clay
            self.obsidian = obsidian
            self.geode = geode
            self.oreRobots = oreRobots
            self.clayRobots = clayRobots
            self.obsidianRobots = obsidianRobots
            self.geodeRobots = geodeRobots
            self.timeRemaining = timeRemaining
        }
    }
    
    public func run(blueprint: Blueprint, minutes: Int) -> Int {
        var queue = [State(0, 0, 0, 0, 1, 0, 0, 0, minutes)]
        var seen = Set<State>()
        var best = 0
        
        while let state = queue.popLast() {
            var ore = state.ore
            var clay = state.clay
            var obsidian = state.obsidian
            let geode = state.geode
            var oreRobots = state.oreRobots
            var clayRobots = state.clayRobots
            var obsidianRobots = state.obsidianRobots
            let geodeRobots = state.geodeRobots
            let timeRemaining = state.timeRemaining
            
            best = max(best, geode)
            guard timeRemaining > 0 else { continue }
            
            let core = max(blueprint.oreCost , blueprint.clayRobotOreCost, blueprint.obsidianRobotCostOre, blueprint.geodeRobotCostOre)
            if oreRobots > core {
                oreRobots = core
            }
            if clayRobots > blueprint.obsidianRobotCostClay {
                clayRobots = blueprint.obsidianRobotCostClay
            }
            if obsidianRobots > blueprint.geodeRobotCostObsidian {
                obsidianRobots = blueprint.geodeRobotCostObsidian
            }
            if ore >= timeRemaining * core - oreRobots * (timeRemaining - 1) {
                ore = timeRemaining * core - oreRobots * (timeRemaining - 1)
            }
            if clay >= timeRemaining * blueprint.obsidianRobotCostClay - clayRobots * (timeRemaining - 1) {
                clay = timeRemaining * blueprint.obsidianRobotCostClay - clayRobots * (timeRemaining - 1)
            }
            if obsidian >= timeRemaining * blueprint.geodeRobotCostObsidian - obsidianRobots * (timeRemaining - 1) {
                obsidian = timeRemaining * blueprint.geodeRobotCostObsidian - obsidianRobots * (timeRemaining - 1)
            }
            
            let newState = State(ore, clay, obsidian, geode, oreRobots, clayRobots, obsidianRobots, geodeRobots, timeRemaining - 1)
            guard !seen.contains(newState) else { continue }
            seen.insert(newState)
            
            queue.append(State(ore + oreRobots, clay + clayRobots, obsidian + obsidianRobots, geode + geodeRobots, oreRobots, clayRobots, obsidianRobots, geodeRobots, timeRemaining - 1))
            if ore >= blueprint.oreCost {
                queue.append(State(ore - blueprint.oreCost + oreRobots, clay + clayRobots, obsidian + obsidianRobots, geode + geodeRobots, oreRobots + 1, clayRobots, obsidianRobots, geodeRobots, timeRemaining - 1))
            }
            if ore >= blueprint.clayRobotOreCost {
                queue.append(State(ore - blueprint.clayRobotOreCost + oreRobots, clay + clayRobots, obsidian + obsidianRobots, geode + geodeRobots, oreRobots, clayRobots + 1, obsidianRobots, geodeRobots, timeRemaining - 1))
            }
            if ore >= blueprint.obsidianRobotCostOre && clay >= blueprint.obsidianRobotCostClay {
                queue.append(State(ore - blueprint.obsidianRobotCostOre + oreRobots, clay - blueprint.obsidianRobotCostClay + clayRobots, obsidian + obsidianRobots, geode + geodeRobots, oreRobots, clayRobots, obsidianRobots + 1, geodeRobots, timeRemaining - 1))
            }
            if ore >= blueprint.geodeRobotCostOre && obsidian >= blueprint.geodeRobotCostObsidian {
                queue.append(State(ore - blueprint.geodeRobotCostOre + oreRobots, clay + clayRobots, obsidian - blueprint.geodeRobotCostObsidian + obsidianRobots, geode + geodeRobots, oreRobots, clayRobots, obsidianRobots, geodeRobots + 1, timeRemaining - 1))
            }
        }
        
        return best
    }
}

extension Day19 {
    private func printEndSummary(_ currentOreRobots: Int, _ ore: Int, _ currentClayRobots: Int, _ clay: Int, _ currentObsidianRobots: Int, _ obsidian: Int, _ currentGeodeRobots: Int, _ geode: Int, _ oreRobots: Int, _ clayRobots: Int, _ obsidianRobots: Int, _ geodeRobots: Int) {
        print("\(currentOreRobots) ore-collecting robot collects \(currentOreRobots) ore; you now have \(ore) ore.")
        if currentClayRobots > 0 {
            print("\(currentClayRobots) clay-collecting robots collect \(currentClayRobots) clay; you now have \(clay) clay.")
        }
        if currentObsidianRobots > 0 {
            print("\(currentObsidianRobots) obsidian-collecting robots collect \(currentObsidianRobots) obsidian; you now have \(obsidian) obsidian.")
        }
        if currentGeodeRobots > 0 {
            print("\(currentGeodeRobots) geode-cracking robot cracks \(currentGeodeRobots) geode; you now have \(geode) open geode.")
        }
        
        if oreRobots != currentOreRobots {
            print("The new ore-collecting robot is ready; you now have \(oreRobots) of them.")
        }
        if clayRobots != currentClayRobots {
            print("The new clay-collecting robot is ready; you now have \(clayRobots) of them.")
        }
        if obsidianRobots != currentObsidianRobots {
            print("The new obsidian-collecting robot is ready; you now have \(obsidianRobots) of them.")
        }
        if geodeRobots != currentGeodeRobots {
            print("The new geode-collecting robot is ready; you now have \(geodeRobots) of them.")
        }
        
        print()
    }
}

extension Day19 {
    public struct Blueprint {
        public let id: Int
        public let oreCost: Int
        public let clayRobotOreCost: Int
        public let obsidianRobotCostOre: Int
        public let obsidianRobotCostClay: Int
        public let geodeRobotCostOre: Int
        public let geodeRobotCostObsidian: Int
        
        public init(_ input: String) {
            let components = input.components(separatedBy: "|")
            self.id = Int(components[0])!
            self.oreCost = Int(components[1])!
            self.clayRobotOreCost = Int(components[2])!
            self.obsidianRobotCostOre = Int(components[3])!
            self.obsidianRobotCostClay = Int(components[4])!
            self.geodeRobotCostOre = Int(components[5])!
            self.geodeRobotCostObsidian = Int(components[6])!
        }
    }
    
    public func parse(_ input: String) -> [Blueprint] {
        input
            .replacingOccurrences(of: "Blueprint ", with: "")
            .replacingOccurrences(of: ": Each ore robot costs ", with: "|")
            .replacingOccurrences(of: " ore. Each clay robot costs ", with: "|")
            .replacingOccurrences(of: " ore. Each obsidian robot costs ", with: "|")
            .replacingOccurrences(of: " ore and ", with: "|")
            .replacingOccurrences(of: " clay. Each geode robot costs ", with: "|")
            .replacingOccurrences(of: " obsidian.", with: "")
            .lines
            .map(Blueprint.init)
    }
}
