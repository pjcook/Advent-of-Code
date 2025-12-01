import Foundation
import StandardLibraries

public struct Day1 {
    public enum Instruction: CustomStringConvertible {
        case left(Int)
        case right(Int)

        public init?(_ value: String) {
            let first = value.first!
            let number = value.dropFirst()
            switch first {
                case "L": self = .left(Int(number)!)
                default: self = .right(Int(number)!)
            }
        }

        public var description: String {
            switch self {
                case let .left(amount): "L\(amount)"
                case let .right(amount): "R\(amount)"
            }
        }

        public var amount: Int {
            switch self {
                case let .left(amount): -amount
                case let .right(amount): amount
            }
        }
    }
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var count = 0
        var dial = 50
        let instructions = extractInstructions(input)

        for instruction in instructions {
            dial += instruction.amount

            if dial < 0 {
                while dial < 0 {
                    dial += 100
                }
            } else {
                dial = dial % 100
            }

            if dial == 0 {
                count += 1
            }
//            print(dial, count)
        }

        return count
    }
    
    public func part2(_ input: [String]) -> Int {
        var count = 0
        var dial = 50
        let instructions = extractInstructions(input)

        for instruction in instructions {
            let previous = dial
            dial += instruction.amount
            if dial == 0 {
                count += 1
            } else if dial < 0 {
                if previous == 0, dial < 0 {
                    dial += 100
                }

                while dial < 0 {
                    dial += 100
                    count += 1
                }

                if dial == 0 {
                    count += 1
                }
            } else {
                if dial != 0, dial % 100 == 0 {
                    dial -= 100
                }

                while dial > 99 {
                    dial -= 100
                    count += 1
                }

                if dial == 0 {
                    count += 1
                }
            }

//            print(instruction, dial, count)
        }

        return count
    }
}

extension Day1 {
    public func extractInstructions(_ input: [String]) -> [Instruction] {
        input.compactMap(Instruction.init)
    }
}
