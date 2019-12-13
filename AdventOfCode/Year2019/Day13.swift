//
//  Day13.swift
//  Year2019
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

enum BlockTile: Int {
    case empty = 0
    case wall = 1
    case block = 2
    case horizontalPaddle = 3
    case ball = 4
}

enum Joystick: Int {
    case neutral = 0
    case left = -1
    case right = 1
}

func runGame(_ input: [Int]) -> Int {
    let bigInput = input + Array(repeating: 0, count: 2000)
    var output = [Int]()
    let computer = AdvancedIntCodeComputer(data: bigInput)
    _ = computer.process({ 0 }, processOutput: { output.append($0) }, finished: nil, forceWriteMode: false)
    var gameInstructions = [Point:BlockTile]()
    _ = output.chunked(into: 3).map {
        gameInstructions[Point(x: $0[0], y: $0[1])] = BlockTile(rawValue: $0[2])
    }
    let blockTiles = gameInstructions.compactMap { $0.value == .block ? $0 : nil }
    drawGameBoard(gameInstructions)
    return blockTiles.count
}

fileprivate func convertOutputToGameInstructions(_ output: [Int], _ gameInstructions: inout [Point : BlockTile]) {
    _ = output.chunked(into: 3).map {
        gameInstructions[Point(x: $0[0], y: $0[1])] = BlockTile(rawValue: $0[2])
    }
}

func playGame(_ input: [Int]) -> Int {
    let bigInput = input + Array(repeating: 0, count: 2000)
    var output = [Int]()
    let computer = AdvancedIntCodeComputer(data: bigInput)
    var gameInstructions = [Point:BlockTile]()
    var finalScore = 0
    let finalScoreID = Point(x: -1, y: 0)
    
    _ = computer.process(
        {
//            convertOutputToGameInstructions(output, &gameInstructions)
//            drawGameBoard(gameInstructions)
            let paddlePosition = gameInstructions.first { $1 == .horizontalPaddle }
            let ballPosition = gameInstructions.first { $1 == .ball }
            if paddlePosition!.key.x == ballPosition!.key.x { return 0 }
            if paddlePosition!.key.x < ballPosition!.key.x { return 1 }
            if paddlePosition!.key.x > ballPosition!.key.x { return -1 }
            return 0
        },
        processOutput: {
            output.append($0)
            if output.count == 3 {
                let x = output.removeFirst()
                let y = output.removeFirst()
                let b = output.removeFirst()
                let point = Point(x: x, y: y)
                if point == finalScoreID {
                    finalScore = b
                } else {
                    gameInstructions[Point(x: x, y: y)] = BlockTile(rawValue: b)
                }
            }
        },
        finished: nil,
        forceWriteMode: false)
    
//    convertOutputToGameInstructions(output, &gameInstructions)
//    drawGameBoard(gameInstructions)
    return finalScore
}

func drawGameBoard(_ instruction: [Point:BlockTile]) {
    let minX = instruction.reduce(0) { min($0,$1.key.x) }
    let minY = instruction.reduce(0) { min($0,$1.key.y) }
    let maxX = instruction.reduce(0) { max($0,$1.key.x) }
    let maxY = instruction.reduce(0) { max($0,$1.key.y) }
    var map = ""

    for y in (0...maxY-minY) {
        var row = ""
        for x in 0...maxX - minX {
            let dx = x + minX
            let dy = y + minY
            let value = instruction[Point(x: dx, y: dy)] ?? .empty
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
