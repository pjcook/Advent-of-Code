//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day10 {
    public init() {}
    
    public func part1(_ input: [String], find: [Int]) -> Int {
        let bots = parse(input)
        var outputs = [Int: Int]()
        
        while bots.values.filter({ $0.values.count != 2 }).count > 0 {
            for bot in bots.values.filter({ $0.values.count == 2 }) {
                let l = bot.values.sorted().first!
                let h = bot.values.sorted().last!
                switch bot.low {
                case .bot(let botID):
                    bots[botID]!.values.insert(l)
                case .output(let index):
                    outputs[index] = l
                }
                
                switch bot.high {
                case .bot(let botID):
                    bots[botID]!.values.insert(h)
                case .output(let index):
                    outputs[index] = h
                }
            }
        }
        
        let sortedFind = find.sorted()
        for bot in bots.values {
            if bot.values.sorted() == sortedFind {
                return bot.id
            }
        }
        return -1
    }
    
    public func part2(_ input: [String]) -> Int {
        let bots = parse(input)
        var outputs = [Int: Int]()
        
        while bots.values.filter({ $0.values.count != 2 }).count > 0 {
            for bot in bots.values.filter({ $0.values.count == 2 }) {
                let l = bot.values.sorted().first!
                let h = bot.values.sorted().last!
                switch bot.low {
                case .bot(let botID):
                    bots[botID]!.values.insert(l)
                case .output(let index):
                    outputs[index] = l
                }
                
                switch bot.high {
                case .bot(let botID):
                    bots[botID]!.values.insert(h)
                case .output(let index):
                    outputs[index] = h
                }
            }
        }
        
        for bot in bots.values {
            let l = bot.values.sorted().first!
            let h = bot.values.sorted().last!
            switch bot.low {
            case .bot(let botID):
                bots[botID]!.values.insert(l)
            case .output(let index):
                outputs[index] = l
            }
            
            switch bot.high {
            case .bot(let botID):
                bots[botID]!.values.insert(h)
            case .output(let index):
                outputs[index] = h
            }
        }
        
        return [outputs[0, default: 1], outputs[1, default: 1], outputs[2, default: 1]].reduce(1, *)
    }
    
    final class Bot {
        let id: Int
        let low: Destination
        let high: Destination
        var values: Set<Int> = []
        
        init(id: Int, low: Destination, high: Destination) {
            self.id = id
            self.low = low
            self.high = high
        }
    }
    
    enum Destination {
        case bot(Int)
        case output(Int)
    }
}

extension Day10 {
    func parse(_ input: [String]) -> [Int: Bot] {
        var spareValues = [(Int, Int)]()
        var bots: [Int: Bot] = [:]
        
        for line in input {
            if line.hasPrefix("value") {
                let values = line
                    .replacingOccurrences(of: "value ", with: "")
                    .replacingOccurrences(of: "goes to bot ", with: "")
                    .split(separator: " ")
                    .map({ Int($0)! })
                
                if let bot = bots[values[1]] {
                    bot.values.insert(values[0])
                } else {
                    spareValues.append((values[0], values[1]))
                }
            } else if line.hasPrefix(("bot")) {
                if line.contains("gives low to bot ") {
                    if line.contains("and high to bot ") {
                        let values = line
                            .replacingOccurrences(of: "gives low to bot ", with: "")
                            .replacingOccurrences(of: "and high to bot ", with: "")
                            .replacingOccurrences(of: "bot ", with: "")
                            .split(separator: " ")
                            .map({ Int($0)! })
                        let bot = Bot(id: values[0], low: .bot(values[1]), high: .bot(values[2]))
                        bots[values[0]] = bot
                    } else {
                        let values = line
                            .replacingOccurrences(of: "gives low to bot ", with: "")
                            .replacingOccurrences(of: "and high to output ", with: "")
                            .replacingOccurrences(of: "bot ", with: "")
                            .split(separator: " ")
                            .map({ Int($0)! })
                        let bot = Bot(id: values[0], low: .bot(values[1]), high: .output(values[2]))
                        bots[values[0]] = bot
                    }
                } else {
                    if line.contains("and high to bot ") {
                        let values = line
                            .replacingOccurrences(of: "gives low to output ", with: "")
                            .replacingOccurrences(of: "and high to bot ", with: "")
                            .replacingOccurrences(of: "bot ", with: "")
                            .split(separator: " ")
                            .map({ Int($0)! })
                        let bot = Bot(id: values[0], low: .output(values[1]), high: .bot(values[2]))
                        bots[values[0]] = bot
                    } else {
                        let values = line
                            .replacingOccurrences(of: "gives low to output ", with: "")
                            .replacingOccurrences(of: "and high to output ", with: "")
                            .replacingOccurrences(of: "bot ", with: "")
                            .split(separator: " ")
                            .map({ Int($0)! })
                        let bot = Bot(id: values[0], low: .output(values[1]), high: .output(values[2]))
                        bots[values[0]] = bot
                    }
                }
            } else {
                fatalError("Boom!")
            }
        }
        
        for (value, botID) in spareValues {
            let bot = bots[botID]!
            bot.values.insert(value)
        }
        
        return bots
    }
}
