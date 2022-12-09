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
                moveTail(head: tail1, tail: &tail2, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail2, tail: &tail3, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail3, tail: &tail4, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail4, tail: &tail5, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail5, tail: &tail6, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail6, tail: &tail7, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail7, tail: &tail8, shouldTrack: false, points: &points, direction: movement.direction)
                moveTail(head: tail8, tail: &tail9, shouldTrack: true, points: &points, direction: movement.direction)

//                draw(points: points, head: head, tail1: tail1, tail2: tail2, tail3: tail3, tail4: tail4, tail5: tail5, tail6: tail6, tail7: tail7, tail8: tail8, tail9: tail9)
            }
        }

        return points.count
    }
}

extension Day9 {
    func draw(points: Set<Point>, head: Point, tail1: Point, tail2: Point, tail3: Point, tail4: Point, tail5: Point, tail6: Point, tail7: Point, tail8: Point, tail9: Point) {
        var positions = points
        positions.insert(head)
        positions.insert(tail1)
        positions.insert(tail2)
        positions.insert(tail3)
        positions.insert(tail4)
        positions.insert(tail5)
        positions.insert(tail6)
        positions.insert(tail7)
        positions.insert(tail8)
        positions.insert(tail9)
        let (minPoint, _) = positions.minMax()
        
        let side = 30
        var grid = Grid<String>(columns: side, items: Array(repeating: ".", count: side*side))
        let adder = Point(abs(minPoint.x), abs(minPoint.y))
        grid[head + adder] = "H"
        grid[tail1 + adder] = "1"
        grid[tail2 + adder] = "2"
        grid[tail3 + adder] = "3"
        grid[tail4 + adder] = "4"
        grid[tail5 + adder] = "5"
        grid[tail6 + adder] = "6"
        grid[tail7 + adder] = "7"
        grid[tail8 + adder] = "8"
        grid[tail9 + adder] = "9"
        
        for p in points {
            grid[p + adder] = "#"
        }
        
        grid[adder] = "s"

        grid.draw()
        print()
    }
    
    func move(head: inout Point, tail: inout Point, shouldTrack: Bool, points: inout Set<Point>, direction: Direction) {
        switch direction {
        case .up:
            head = head.up()
            let headNeighbors = head.neighbors(true, max: nil)
            if head != tail, !headNeighbors.contains(tail) {
                tail = head.down()
                if shouldTrack {
                    points.insert(tail)
                }
            }
        case .down:
            head = head.down()
            let headNeighbors = head.neighbors(true, max: nil)
            if head != tail, !headNeighbors.contains(tail) {
                tail = head.up()
                if shouldTrack {
                    points.insert(tail)
                }
            }
        case .left:
            head = head.left()
            let headNeighbors = head.neighbors(true, max: nil)
            if head != tail, !headNeighbors.contains(tail) {
                tail = head.right()
                if shouldTrack {
                    points.insert(tail)
                }
            }
        case .right:
            head = head.right()
            let headNeighbors = head.neighbors(true, max: nil)
            if head != tail, !headNeighbors.contains(tail) {
                tail = head.left()
                if shouldTrack {
                    points.insert(tail)
                }
            }
        }
    }
    
    func moveTail(head: Point, tail: inout Point, shouldTrack: Bool, points: inout Set<Point>, direction: Direction) {
        let headNeighbors = head.neighbors(true, max: nil)
        if head != tail, !headNeighbors.contains(tail) {
            tail = headNeighbors.intersection(tail.neighbors(true, max: nil)).sorted(by: { head.manhattanDistance(to: $0) < head.manhattanDistance(to: $1) }).first ?? tail
            if shouldTrack {
                points.insert(tail)
            }
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
