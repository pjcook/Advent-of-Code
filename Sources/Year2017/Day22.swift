//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
    
    typealias System = [Point: Int]
    
    public func part1(_ input: [String], bursts: Int) -> Int {
        var system = parse(input)
        var point = Point(input.count / 2, input.count / 2)
        var direction = Direction.up
        var count = 0
        
        for _ in 0..<bursts {
            if system[point, default: 0] == 0 {
                system[point] = 1
                direction = direction.rotateLeft()
                count += 1
            } else {
                system[point] = 0
                direction = direction.rotateRight()
            }
            point = point + direction.point
//            draw(system: system, point: point, direction: direction)
        }
        
//        draw(system: system, point: point, direction: direction)
        
        return count
    }
    
    enum State: Int {
        case clean = 0
        case infected = 1
        case weakened = 2
        case flagged = 3
        
        func changeDirection(direction: Direction) -> Direction {
            switch self {
            case .clean:
                return direction.rotateLeft()
                
            case .infected:
                return direction.rotateRight()
                
            case .weakened:
                return direction
                
            case .flagged:
                return direction.rotateLeft().rotateLeft()
            }
        }
        
        func newState() -> State {
            switch self {
            case .clean: .weakened
            case .infected: .flagged
            case .weakened: .infected
            case .flagged: .clean
            }
        }
    }
    
    public func part2(_ input: [String], bursts: Int) -> Int {
        var system = parse(input)
        var point = Point(input.count / 2, input.count / 2)
        var direction = Direction.up
        var count = 0
        
        for _ in 0..<bursts {
            let state = State(rawValue: system[point, default: 0])!
            direction = state.changeDirection(direction: direction)
            system[point] = state.newState().rawValue
            if state == .weakened { count += 1 }
            point = point + direction.point
        }
        
        return count
    }
}

extension Day22 {
    func draw(system: System, point: Point, direction: Direction) {
        let (dmin, dmax) = system.keys.extremes()
        let dx = dmax.x - min(point.x, dmin.x) + 1
        let dy = dmax.y - min(point.y, dmin.y) + 1
        let dp = Point(abs(min(point.x, dmin.x)), abs(min(point.y, dmin.y)))
        var grid = Grid<String>(size: Point(dx, dy), fill: ".")
        for (point, value) in system where value == 1 {
            grid[point + dp] = "#"
        }
        
        switch direction {
        case .up: grid[point + dp] = "^"
        case .down: grid[point + dp] = "v"
        case .left: grid[point + dp] = "<"
        case .right: grid[point + dp] = ">"
        }
        
        print("Final point", grid[point + dp] == "#" ? "filled" : "empty")
        grid.draw()
        print()
    }
    
    func parse(_ input: [String]) -> System {
        var system: System = [:]
        
        for y in 0..<input.count {
            let row = input[y]
            for x in 0..<row.count {
                system[Point(x,y)] = row[x] == "#" ? 1 : 0
            }
        }
        
        return system
    }
}
