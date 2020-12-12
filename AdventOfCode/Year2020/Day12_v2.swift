import Foundation
import StandardLibraries

public struct Day12_v2 {
    public init() {}
    
    public enum Instruction {
        case forward(Int)
        case move(Direction, Int)
        case turnLeft(Int)
        case turnRight(Int)
        
        static func from(_ input: String) -> Instruction {
            var instruction = input
            let action = instruction.removeFirst()
            let value = Int(instruction)!
            
            switch action {
            case "N": return .move(.n, value)
            case "S": return .move(.s, value)
            case "E": return .move(.e, value)
            case "W": return .move(.w, value)
            case "L": return .turnLeft(value / 90)
            case "R": return .turnRight(value / 90)
            case "F": return .forward(value)
            default: assertionFailure()
            }
            return forward(-1)
        }
    }
    
    public func parse(_ input: [String]) -> [Instruction] {
        return input.map(Instruction.from)
    }
    
    public func part1(_ input: [String]) -> Int {
        let instructions = parse(input)
        var point = Point.zero
        var direction = Direction.e
        
        for instruction in instructions {
            switch instruction {
            case let .move(direction, value): point = point.add(direction: direction, distance: value)
            case let .forward(value): point = point.add(direction: direction, distance: value)
            case let .turnLeft(value): direction = direction.rotateLeft(times: value)
            case let .turnRight(value): direction = direction.rotateRight(times: value)
            }
        }
        
        return point.manhattanDistance
    }
    
    public func part2(_ input: [String]) -> Int {
        let instructions = parse(input)
        var point = Point.zero
        var wayPoint = Point(x: 10, y: 1)
        
        for instruction in instructions {
            switch instruction {
            case let .move(direction, value): wayPoint = wayPoint.add(direction: direction, distance: value)
            case let .forward(value): point = point + wayPoint * value
            case let .turnLeft(value): wayPoint = wayPoint.rotateLeft(times: value)
            case let .turnRight(value): wayPoint = wayPoint.rotateRight(times: value)
            }
        }
        
        return point.manhattanDistance
    }
}
