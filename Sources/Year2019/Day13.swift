//
//  Day13.swift
//  Year2019
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day13 {
    private var finished = false
    private var output: [Int] = []
    private var part2Output = 0
    private var gameInstructions = [Point: BlockTile]()
    private var isPart2 = false
    
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        output = []
        isPart2 = false
        
        while !finished {
            computer.tick()
        }
        
        var gameInstructions = [Point:BlockTile]()
        _ = output.chunked(into: 3).map {
            gameInstructions[Point(x: $0[0], y: $0[1])] = BlockTile(rawValue: $0[2])
        }
        let blockTiles = gameInstructions.compactMap { $0.value == .block ? $0 : nil }
    //    drawGameBoard(gameInstructions, score: 0)
        return blockTiles.count
    }
    
    public func part2(_ input: [Int]) -> Int {
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        output = []
        part2Output = 0
        gameInstructions = [Point: BlockTile]()
        isPart2 = true
        
        while !finished {
            computer.tick()
        }
        
        return part2Output
    }
}

extension Day13: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        guard isPart2 else { return 0 }
        let paddlePosition = gameInstructions.first { $1 == .horizontalPaddle }
        let ballPosition = gameInstructions.first { $1 == .ball }
        if paddlePosition!.key.x == ballPosition!.key.x { return 0 }
        if paddlePosition!.key.x < ballPosition!.key.x { return 1 }
        if paddlePosition!.key.x > ballPosition!.key.x { return -1 }
        return 0
    }
    
    public func computerFinished(id: Int) {
        finished = true
    }
    
    public func processOutput(id: Int, value: Int) {
        output.append(value)
        if isPart2, output.count == 3 {
            let x = output.removeFirst()
            let y = output.removeFirst()
            let b = output.removeFirst()
            let point = Point(x: x, y: y)
            if point == Point(x: -1, y: 0) {
                part2Output = b
            } else {
                gameInstructions[point] = BlockTile(rawValue: b)
            }
        }
    }
}

public enum BlockTile: Int {
    case empty = 0
    case wall = 1
    case block = 2
    case horizontalPaddle = 3
    case ball = 4
}

public enum Joystick: Int {
    case neutral = 0
    case left = -1
    case right = 1
}

public func drawGameBoard(_ instruction: [Point:BlockTile], score: Int) {
    let minX = instruction.reduce(0) { min($0,$1.key.x) }
    let minY = instruction.reduce(0) { min($0,$1.key.y) }
    let maxX = instruction.reduce(0) { max($0,$1.key.x) }
    let maxY = instruction.reduce(0) { max($0,$1.key.y) }
    var map = "SCORE: \(score)\n"

    for y in (0...maxY-minY) {
        var row = ""
        for x in 0...maxX - minX {
            let dx = x + minX
            let dy = y + minY
            let value = instruction[Point(x: dx, y: dy), default: .empty]
            switch value {
                case .empty: row += "⚫️"
                case .wall: row += "🟤"
                case .block: row += "🟠"
                case .horizontalPaddle: row += "🟪"
                case .ball: row += "⚪️"
            }
        }
        map += row + "\n"
    }
    // hKthH7kh
    print(map + "\n")
}
