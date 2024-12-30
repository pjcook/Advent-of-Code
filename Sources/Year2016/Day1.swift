//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        var point = Point.zero
        var direction: CompassDirection = .n
        
        for move in parse(input) {
            direction = move.turn == .right ? direction.rotateRight() : direction.rotateLeft()
            point = point.add(direction: direction, distance: move.distance)
        }
        
        return abs(point.x) + abs(point.y)
    }
    
    public func part2(_ input: String) -> Int {
        var point = Point.zero
        var direction: Direction = .up
        var seen: Set<Point> = [.zero]
        
        for move in parse(input) {
            direction = move.turn == .right ? direction.rotateRight() : direction.rotateLeft()
            for _ in 0..<move.distance {
                point = point.add(direction: direction)
                if seen.contains(point) { break }
                seen.insert(point)
            }
        }
        
        return point.manhattanDistance(to: .zero) + 1
    }
    
    enum Turn: Character {
        case left = "L"
        case right = "R"
    }
    
    struct Move: Hashable {
        let turn: Turn
        let distance: Int
    }
}

extension Day1 {
    func parse(_ input: String) -> [Move] {
        var movements: [Move] = []
        
        for comp in input.split(separator: ", ") {
            var comp = comp
            let turn = Turn(rawValue: comp.removeFirst())!
            let distance = Int(comp)!
            movements.append(Move(turn: turn, distance: distance))
        }
        
        return movements
    }
}
