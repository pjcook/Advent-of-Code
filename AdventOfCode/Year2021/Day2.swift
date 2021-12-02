import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public enum Command {
        case up(Int)
        case down(Int)
        case forward(Int)
    }
    
    public func part1(_ input: [String]) -> Int {
        let commands = parse(input)
        var depth = 0
        var horizontal = 0
        for command in commands {
            switch command {
            case let .forward(value): horizontal += value
            case let .up(value): depth -= value
            case let .down(value): depth += value
            }
        }
        return depth * horizontal
    }
    
    public func part2(_ input: [String]) -> Int {
        let commands = parse(input)
        var depth = 0
        var horizontal = 0
        var aim = 0
        for command in commands {
            switch command {
            case let .forward(value):
                horizontal += value
                depth += value * aim
            case let .up(value): aim -= value
            case let .down(value): aim += value
            }
        }
        return depth * horizontal
    }
    
    public func parse(_ input: [String]) -> [Command] {
        var commands = [Command]()
        for line in input {
            if line.hasPrefix("forward ") {
                let value = Int(String(line.last!))!
                commands.append(.forward(value))
            } else if line.hasPrefix("up ") {
                let value = Int(String(line.last!))!
                commands.append(.up(value))
            } else if line.hasPrefix("down ") {
                let value = Int(String(line.last!))!
                commands.append(.down(value))
            }
        }
        return commands
    }
}
