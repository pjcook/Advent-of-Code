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
            let value = Int(String(line.last!))!
            if line.hasPrefix("f") {
                commands.append(.forward(value))
            } else if line.hasPrefix("u") {
                commands.append(.up(value))
            } else if line.hasPrefix("d") {
                commands.append(.down(value))
            }
        }
        return commands
    }
    
    public func part1b(_ input: [String]) -> Int {
        var depth = 0
        var horizontal = 0
        for line in input {
            let value = Int(String(line.last!))!
            if line.hasPrefix("f") {
                horizontal += value
            } else if line.hasPrefix("u") {
                depth -= value
            } else if line.hasPrefix("d") {
                depth += value
            }
        }
        return depth * horizontal
    }
    
    public func part2b(_ input: [String]) -> Int {
        var depth = 0
        var horizontal = 0
        var aim = 0
        for line in input {
            let value = Int(String(line.last!))!
            if line.hasPrefix("f") {
                horizontal += value
                depth += value * aim
            } else if line.hasPrefix("u") {
                aim -= value
            } else if line.hasPrefix("d") {
                aim += value
            }
        }
        return depth * horizontal
    }
    
    public let regex = try! RegularExpression(pattern: "^(forward|up|down) (\\d+)$")

    public func part1c(_ input: [String]) throws -> Int {
        var depth = 0
        var horizontal = 0
        for line in input {
            let match = try regex.match(line)
            let command = try match.string(at: 0)
            let value = try match.integer(at: 1)
            if command == "forward" {
                horizontal += value
            } else if command == "up" {
                depth -= value
            } else if command == "down" {
                depth += value
            }
        }
        return depth * horizontal
    }
    
    public func part2c(_ input: [String]) throws -> Int {
        var depth = 0
        var horizontal = 0
        var aim = 0
        for line in input {
            let match = try regex.match(line)
            let command = try match.string(at: 0)
            let value = try match.integer(at: 1)
            if command == "forward" {
                horizontal += value
                depth += value * aim
            } else if command == "up" {
                aim -= value
            } else if command == "down" {
                aim += value
            }
        }
        return depth * horizontal
    }
}
