//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let movements = parse(input)
        var points = Set<Point>()
        var head = Point.zero
        var tail = Point.zero
        points.insert(tail)
        
        for movement in movements {
            for _ in (0..<movement.value) {
                move(head: &head, tail: &tail, shouldTrack: true, points: &points, direction: movement.direction)
            }
        }
        
        return points.count
    }
    
    public func part2(_ input: [String]) -> Int {
        let movements = parse(input)
        var points = Set<Point>()
        var head = Point.zero
        var tail1 = Point.zero
        var tail2 = Point.zero
        var tail3 = Point.zero
        var tail4 = Point.zero
        var tail5 = Point.zero
        var tail6 = Point.zero
        var tail7 = Point.zero
        var tail8 = Point.zero
        var tail9 = Point.zero
        points.insert(tail9)
        
        for movement in movements {
            for _ in (0..<movement.value) {
                move(head: &head, tail: &tail1, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail1, tail: &tail2)
                moveTail(head: tail2, tail: &tail3)
                moveTail(head: tail3, tail: &tail4)
                moveTail(head: tail4, tail: &tail5)
                moveTail(head: tail5, tail: &tail6)
                moveTail(head: tail6, tail: &tail7)
                moveTail(head: tail7, tail: &tail8)
                points = moveTail(head: tail8, tail: &tail9, points: points)!
//                draw(points: points, head: head, tail1: tail1, tail2: tail2, tail3: tail3, tail4: tail4, tail5: tail5, tail6: tail6, tail7: tail7, tail8: tail8, tail9: tail9)
            }
        }

        return points.count
    }
}

extension Day9 {
    func move(head: inout Point, tail: inout Point, shouldTrack: Bool, points: inout Set<Point>, direction: Direction) {
        if move(head: &head, tail: &tail, direction: direction), shouldTrack {
            points.insert(tail)
        }
    }
    
    func move(head: inout Point, tail: inout Point, direction: Direction) -> Bool {
        head = head.move(direction)
        guard head != tail else { return false }
        if !head.neighbors(true, max: nil).contains(tail) {
            tail = head.move(direction.opposite)
            return true
        }
        return false
    }
    
    @discardableResult
    func moveTail(head: Point, tail: inout Point, points: Set<Point>? = nil) -> Set<Point>? {
        guard head != tail else { return points }
        let headNeighbors = head.neighbors(true, max: nil)
        var points = points
        if !headNeighbors.contains(tail) {
            tail = headNeighbors.intersection(tail.neighbors(true, max: nil)).sorted(by: { head.manhattanDistance(to: $0) < head.manhattanDistance(to: $1) }).first ?? tail
            points?.insert(tail)
        }
        return points
    }
    
    public func parse(_ input: [String]) -> [SnakeMove] {
        var movements = [SnakeMove]()
        
        for line in input {
            let components = line.components(separatedBy: " ")
            let movement = SnakeMove(direction: Direction(rawValue: components[0])!, value: Int(components[1])!)
            movements.append(movement)
        }
        
        return movements
    }
}

extension Point {
    public func move(_ direction: Day9.Direction) -> Point {
        switch direction {
        case .left: return left()
        case .right: return right()
        case .up: return up()
        case .down: return down()
        }
    }
}

extension Day9 {
    public struct SnakeMove {
        public let direction: Direction
        public let value: Int
    }
    
    public enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
        
        public var opposite: Direction {
            switch self {
            case .up: return .down
            case .down: return .up
            case .left: return .right
            case .right: return .left
            }
        }
    }
}
