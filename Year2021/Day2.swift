import Foundation
import StandardLibraries

public struct Day2 {
    public init() {}
    
    // Submarine commands
    public enum Command {
        case up(Int)
        case down(Int)
        case forward(Int)
    }
        
    /*
     Your horizontal position and depth both start at 0. Follow the steps in the puzzle input to get the horizontal and depth positions, then multiply these together for the answer.
     */
    public func part1(_ input: [String]) -> Int {
        // Parse the puzzle input
        let commands = parse(input)
        var depth = 0
        var horizontal = 0
        // Run each command to calculate the depth and horizontal positions
        for command in commands {
            switch command {
            case let .forward(value): horizontal += value
            case let .up(value): depth -= value
            case let .down(value): depth += value
            }
        }
        // calculate the result
        return depth * horizontal
    }
    
    /*
     Based on your calculations, the planned course doesn't seem to make any sense. You find the submarine manual and discover that the process is actually slightly more complicated.

     In addition to horizontal position and depth, you'll also need to track a third value, aim, which also starts at 0. The commands also mean something entirely different than you first thought:

     • down X increases your aim by X units.
     • up X decreases your aim by X units.
     • forward X does two things:
       - It increases your horizontal position by X units.
       - It increases your depth by your aim multiplied by X.
     
     Now, the above example does something different:

     • forward 5 adds 5 to your horizontal position, a total of 5. Because your aim is 0, your depth does not change.
     • down 5 adds 5 to your aim, resulting in a value of 5.
     • forward 8 adds 8 to your horizontal position, a total of 13. Because your aim is 5, your depth increases by 8*5=40.
     */
    public func part2(_ input: [String]) -> Int {
        // Parse the puzzle input
        let commands = parse(input)
        var depth = 0
        var horizontal = 0
        var aim = 0
        // Run each command to calculate the depth horizontal and aim positions
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
    
    /*
     Parse the input file, instructions look like:
     up 3
     down 8
     forward 2
     
     Hint: scanning the input file by eye, the number is always single digit, and the first letter of each command is unique.
     */
    public func parse(_ input: [String]) -> [Command] {
        var commands = [Command]()
        // process each line in the input file to generate commands
        for line in input {
            // the value is always the last character on the line
            let value = Int(String(line.last!))!
            // through trial and error I figured out that ".hasPrefix()" was the quickest method to determine which command to use
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
    
    // Version that skips the parsing step and simply calculates the answer as it processes each line directly.
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
    
    // Version using regular expressions to process each input line
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
