//
//  Day15.swift
//  Year2019
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day15 {
    private var finished = false
    private var readInputBlock: () -> Int = { 0 }
    private var writeOutputBlock: (Int) -> Void = { _ in }

    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let grid = mapGrid(input)
        let start = grid.points(for: Tile.start.rawValue).first!
        let end = grid.points(for: Tile.os.rawValue).first!
        return grid.dijkstra(start: start, end: end, calculateScore: { _ in 1 }, canEnter: { Tile.emptySpaces.contains(grid[$0]) })
    }
    
    public func part2(_ input: [Int]) -> Int {
        var grid = mapGrid(input)
        let start = grid.points(for: Tile.start.rawValue).first!
        grid[start] = Tile.empty.rawValue
        let oxygenStart = grid.points(for: Tile.os.rawValue).first!
        var longest = 0
        
        grid.points(for: Tile.empty.rawValue).forEach {
            longest = max(longest, grid.dijkstra(start: oxygenStart, end: $0, calculateScore: { _ in 1 }, canEnter: { Tile.emptySpaces.contains(grid[$0]) }))
        }
        
        return longest
    }
}

extension Day15: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        readInputBlock()
    }
    
    public func computerFinished(id: Int) {
        finished = true
    }
    
    public func processOutput(id: Int, value: Int) {
        writeOutputBlock(value)
    }
}

extension Day15 {
    func mapGrid(_ input: [Int]) -> Grid<String> {
        var grid = Grid<String>(size: Point(100,100), fill: Tile.unknown.rawValue)
        var droid = MazeRunner(point: grid.bottomRight / 2, direction: .right)
        grid[droid.point] = Tile.start.rawValue
        var robotState: DroidResponse = .none
        var pointsToTry: [Point: [Direction]] = [droid.point: Direction.allCases]
        var navigationSteps: [Point] = []
        
        func findPointToTry() -> Point? {
            for pointToTry in pointsToTry {
                if !pointToTry.value.isEmpty { return pointToTry.key }
            }
            return nil
        }
        
        func update(point: Point, to: Tile) {
            if !Tile.emptySpaces.contains(grid[point]) {
                grid[point] = to.rawValue
            }
        }
        
        func getRemainingOption(point: Point) -> Direction? {
            var remainingOptions = pointsToTry[droid.point, default: []]
            guard !remainingOptions.isEmpty else { return nil }
            droid.direction = remainingOptions.removeFirst()
            pointsToTry[droid.point] = remainingOptions
            return droid.direction
        }
        
        func readInput() -> Int {
            guard !pointsToTry.isEmpty else { return 99 }
            
            switch robotState {
            case .none:
                return droid.direction.moveValue
                
            case .hitWall:
                update(point: droid.point + droid.direction.point, to: .wall)
                
                // use a remaining option
                if let remainingOption = getRemainingOption(point: droid.point) {
                    droid.direction = remainingOption
                    return remainingOption.moveValue
                }
                
                // Check pointsToTry
                if let point = findPointToTry() {
                    navigationSteps = grid.routeTo(start: droid.point, end: point, emptyBlocks: Tile.emptySpaces)
                    if !navigationSteps.isEmpty {
                        let next = navigationSteps.removeFirst()
                        droid.direction = droid.point.directionTo(next)
                        return droid.direction.moveValue
                    }
                } else {
                    return 99
                }
                
            case .moved:
                update(point: droid.point, to: .empty)
                update(point: droid.point + droid.direction.point, to: .empty)
                
            case .movedFoundOxygenSystem:
                update(point: droid.point, to: .empty)
                update(point: droid.point + droid.direction.point, to: .os)
            }
            
            droid.point = droid.point + droid.direction.point
            if !navigationSteps.isEmpty {
                let next = navigationSteps.removeFirst()
                droid.direction = droid.point.directionTo(next)
                return droid.direction.moveValue
            }
            if pointsToTry[droid.point] == nil, grid[droid.point] == Tile.empty.rawValue {
                pointsToTry[droid.point] = Direction.allCases
            }
            if let remainingOption = getRemainingOption(point: droid.point) {
                droid.direction = remainingOption
                return remainingOption.moveValue
            }
            return droid.direction.moveValue
        }
        
        func processOutput(_ output: Int) {
            robotState = DroidResponse(rawValue: output)!
        }

        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        readInputBlock = readInput
        writeOutputBlock = processOutput
        
        while !finished {
            computer.tick()
        }
        return grid
    }
}

extension Direction {
    init?(_ value: Int) {
        switch value {
        case 1: self = .up
        case 2: self = .down
        case 3: self = .left
        case 4: self = .right
        default : return nil
        }
    }
    
    var moveValue: Int {
        switch self {
        case .up: return 1
        case .down: return 2
        case .left: return 3
        case .right: return 4
        }
    }
}

enum Tile: String {
    case unknown = "?"
    case empty = "."
    case wall = "#"
    case os = "O"
    case start = "S"
    
    static var emptySpaces: [String] {
        [
        Tile.empty.rawValue,
        Tile.os.rawValue,
        Tile.start.rawValue
        ]
    }
}

enum DroidResponse: Int {
    case none = -1
    case hitWall = 0
    case moved = 1
    case movedFoundOxygenSystem = 2
}

public enum MoveStatus: Int {
    case hitWall = 0
    case moved = 1
    case movedFoundOxygenSystem = 2
    case unknown = -1
    case start = 4
    
    public var sortOrder: Int {
        switch self {
        case .unknown: return 0
        case .moved, .start: return 1
        case .movedFoundOxygenSystem: return 2
        case .hitWall: return 3
        }
    }
}
