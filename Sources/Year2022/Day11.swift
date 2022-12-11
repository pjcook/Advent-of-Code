//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    public func part1(_ monkeys: [Monkey]) -> Int {
        let game = MonkeyInTheMiddle(monkeys: monkeys)
        game.round(numberOfRounds: 20) { worryLevel in
            return worryLevel / 3
        }
        return game.monkeys.sorted(by: { $0.inspectedCount > $1.inspectedCount }).prefix(2).map({ $0.inspectedCount }).reduce(1, *)
    }
    
    public func part2(_ monkeys: [Monkey]) -> Int {
        let game = MonkeyInTheMiddle(monkeys: monkeys)
        // Reduce the number using modulo of the lowestCommonMultiplier since addition and multiplication work the same under
        // modulo lowestCommonMultiplier since all the potential divisors are co-prime.
        // https://en.wikipedia.org/wiki/Modular_arithmetic#Properties
        // Get all the `checkDivisor` values and multiply them together
        let lowestCommonMultiplier = game.monkeys.map({ $0.checkDivisor }).reduce(1, *)
        game.round(numberOfRounds: 10000) { worryLevel in
            return worryLevel % lowestCommonMultiplier
        }
        return game.monkeys.sorted(by: { $0.inspectedCount > $1.inspectedCount }).prefix(2).map({ $0.inspectedCount }).reduce(1, *)
    }
}

extension Day11 {
    public class MonkeyInTheMiddle {
        public var monkeys: [Monkey]
        
        public init(monkeys: [Monkey]) {
            self.monkeys = monkeys
        }
        
        public func round(numberOfRounds: Int, reduceWorry: Monkey.ReduceWorry) {
            for _ in (0..<numberOfRounds) {
                for monkey in monkeys {
                    monkey.inspectItems(monkeys, reduceWorry: reduceWorry)
                }
            }
        }
    }
    
    public class Monkey {
        public typealias ReduceWorry = (Int) -> Int
        
        public var inspectedCount = 0
        public var list: [Int]
        public let operation: Operation
        public let checkDivisor: Int
        public let checkTrue: Int
        public let checkFalse: Int
        
        public init(inspectedCount: Int = 0, list: [Int], operation: Operation, checkDivisor: Int, checkTrue: Int, checkFalse: Int) {
            self.inspectedCount = inspectedCount
            self.list = list
            self.operation = operation
            self.checkDivisor = checkDivisor
            self.checkTrue = checkTrue
            self.checkFalse = checkFalse
        }
        
        public func inspectItems(_ monkeys: [Monkey], reduceWorry: ReduceWorry) {
            var itemsToInspect = list
            list = []
            while !itemsToInspect.isEmpty {
                inspectedCount += 1
                var worryLevel = itemsToInspect.removeFirst()
                switch operation {
                case .add(let value): worryLevel += value
                case .multiply(let value): worryLevel *= value
                case .double: worryLevel *= worryLevel
                }
                
                worryLevel = reduceWorry(worryLevel)
                
                if worryLevel % checkDivisor == 0 {
                    monkeys[checkTrue].list.append(worryLevel)
                } else {
                    monkeys[checkFalse].list.append(worryLevel)
                }
            }
        }
    }
    
    public enum Operation {
        case add(Int)
        case multiply(Int)
        case double
    }
}

extension Day11 {
    public func monkeys() -> [Monkey] {
        [
            Monkey(list: [75, 63], operation: .multiply(3), checkDivisor: 11, checkTrue: 7, checkFalse: 2),
            Monkey(list: [65, 79, 98, 77, 56, 54, 83, 94], operation: .add(3), checkDivisor: 2, checkTrue: 2, checkFalse: 0),
            Monkey(list: [66], operation: .add(5), checkDivisor: 5, checkTrue: 7, checkFalse: 5),
            Monkey(list: [51, 89, 90], operation: .multiply(19), checkDivisor: 7, checkTrue: 6, checkFalse: 4),
            Monkey(list: [75, 94, 66, 90, 77, 82, 61], operation: .add(1), checkDivisor: 17, checkTrue: 6, checkFalse: 1),
            Monkey(list: [53, 76, 59, 92, 95], operation: .add(2), checkDivisor: 19, checkTrue: 4, checkFalse: 3),
            Monkey(list: [81, 61, 75, 89, 70, 92], operation: .double, checkDivisor: 3, checkTrue: 0, checkFalse: 1),
            Monkey(list: [81, 86, 62, 87], operation: .add(8), checkDivisor: 13, checkTrue: 3, checkFalse: 5),
        ]
    }
    
    public func testMonkeys() -> [Monkey] {
        [
            Monkey(list: [79, 98], operation: .multiply(19), checkDivisor: 23, checkTrue: 2, checkFalse: 3),
            Monkey(list: [54, 65, 75, 74], operation: .add(6), checkDivisor: 19, checkTrue: 2, checkFalse: 0),
            Monkey(list: [79, 60, 97], operation: .double, checkDivisor: 13, checkTrue: 1, checkFalse: 3),
            Monkey(list: [74], operation: .add(3), checkDivisor: 17, checkTrue: 0, checkFalse: 1),
        ]
    }
}
