import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    public typealias Board = [Point:State]
    public typealias Board2 = [Point:Int]
    
    public static let turnOnRegex = try! RegularExpression(pattern: "^turn on ([\\d]+),([\\d]+) through ([\\d]+),([\\d]+)$")
    public static let turnOffRegex = try! RegularExpression(pattern: "^turn off ([\\d]+),([\\d]+) through ([\\d]+),([\\d]+)$")
    public static let toggleRegex = try! RegularExpression(pattern: "^toggle ([\\d]+),([\\d]+) through ([\\d]+),([\\d]+)$")
    
    public enum LightState {
        case turnOn(Point,Point)
        case turnOff(Point, Point)
        case toggle(Point, Point)
    }
    
    public enum State {
        case on, off
        
        func toggle() -> State {
            self == .on ? .off : .on
        }
    }
    
    public func parse(_ input: [String]) throws -> [LightState] {
        var instructions = [LightState]()
        
        for line in input {
            if line.hasPrefix("turn on") {
                let match = try Self.turnOnRegex.match(line)
                try instructions.append(.turnOn(Point(match.integer(at: 0), match.integer(at: 1)), Point(match.integer(at: 2), match.integer(at: 3))))
            } else if line.hasPrefix("turn off") {
                let match = try Self.turnOffRegex.match(line)
                try instructions.append(.turnOff(Point(match.integer(at: 0), match.integer(at: 1)), Point(match.integer(at: 2), match.integer(at: 3))))
            } else if line.hasPrefix("toggle") {
                let match = try Self.toggleRegex.match(line)
                try instructions.append(.toggle(Point(match.integer(at: 0), match.integer(at: 1)), Point(match.integer(at: 2), match.integer(at: 3))))
            }
        }
        
        return instructions
    }
    
    public func part1(_ input: [String]) throws -> Int {
        let instructions = try parse(input)
        var board = Board()
        
        for instruction in instructions {
            var start: Point = .zero, end: Point = .zero
            switch instruction {
            case .turnOn(let s, let e):
                start = s
                end = e
            case .turnOff(let s, let e):
                start = s
                end = e
            case .toggle(let s, let e):
                start = s
                end = e
            }
            
            for x in (start.x...end.x) {
                for y in (start.y...end.y) {
                    let point = Point(x,y)
                    switch instruction {
                    case .turnOn:
                        board[point] = .on
                    case .turnOff:
                        board[point] = .off
                    case .toggle:
                        board[point] = board[point, default: .off].toggle()
                    }
                }
            }
        }
        
        return board.reduce(0) { total, value in
            total + (value.value == .on ? 1 : 0)
        }
    }
    
    public func part2(_ input: [String]) throws -> Int {
        let instructions = try parse(input)
        var board = Board2()
        
        for instruction in instructions {
            var start: Point = .zero, end: Point = .zero
            switch instruction {
            case .turnOn(let s, let e):
                start = s
                end = e
            case .turnOff(let s, let e):
                start = s
                end = e
            case .toggle(let s, let e):
                start = s
                end = e
            }
            
            for x in (start.x...end.x) {
                for y in (start.y...end.y) {
                    let point = Point(x,y)
                    switch instruction {
                    case .turnOn:
                        board[point] = board[point, default: 0] + 1
                    case .turnOff:
                        board[point] = max(0, board[point, default: 0] - 1)
                    case .toggle:
                        board[point] = board[point, default: 0] + 2
                    }
                }
            }
        }
        
        return board.reduce(0) { total, value in
            total + value.value
        }
    }
}
