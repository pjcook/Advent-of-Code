//
//  Day15.swift
//  Year2019
//
//  Created by PJ COOK on 15/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

extension Direction {
    var moveValue: Int {
        switch self {
            case .N: return 1
            case .S: return 2
            case .W: return 3
            case .E: return 4
        }
    }
}

enum MoveStatus: Int {
    case hitWall = 0
    case moved = 1
    case movedFoundOxygenSystem = 2
}

class Mapper {
    var map: [Point:MoveStatus] = [.zero:.moved]
    var computer: SteppedIntComputer?
    let tiles = [0:"🟤", 1:"⚫️", 2:"🟠"]
    
    private let startPosition = Point.zero
    private var currentPosition = Point.zero
    private var lastMovement: Direction = .E
    private var lastStatus: MoveStatus = .moved
    private var finished = false
    private var started = false
    
    init(_ input: [Int]) {
        computer = SteppedIntComputer(
            id: 1,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: {},
            forceWriteMode: false
        )
    }
    
    func start() {
        computer?.process()
    }
    
    private func readInput() -> Int {
        guard !finished else { return 99 }
        guard started else {
            started = true
            return lastMovement.moveValue
        }
        
        if lastStatus == .hitWall {
            while true {
                lastMovement = lastMovement.rotateRight()
                let point = currentPosition + lastMovement.point
                if let mapStatus = map[point], mapStatus != .hitWall {
                    break
                }
            }
        } else if lastStatus == .moved {
            let point = currentPosition + lastMovement.rotateLeft().point
            if let mapStatus = map[point], mapStatus != .hitWall {
                lastMovement = lastMovement.rotateLeft()
            }
        }
        
        return lastMovement.moveValue
    }
    
    private func processOutput(_ value: Int) {
        let status = MoveStatus(rawValue: value)!
        switch status {
        case .hitWall:
            let position = currentPosition + lastMovement.point
            map[position] = status
            
        case .moved:
            let position = currentPosition + lastMovement.point
            if (map[position] ?? .moved) != .hitWall {
                map[position] = status
                currentPosition = position
            }
            
        case .movedFoundOxygenSystem:
            let position = currentPosition + lastMovement.point
            map[position] = status
            currentPosition = position
            finished = true
            drawMapInConsole()
        }
    }
    
    private func drawMapInConsole() {
        var rawMap = [Point:Int]()
        _ = map.map { rawMap[$0] = $1.rawValue }
        drawMap(rawMap, tileMap: tiles)
    }
}

func drawMap(_ output: [Point:Int], tileMap: [Int:String]) {
    let minX = output.reduce(0) { min($0,$1.key.x) }
    let minY = output.reduce(0) { min($0,$1.key.y) }
    let maxX = output.reduce(0) { max($0,$1.key.x) }
    let maxY = output.reduce(0) { max($0,$1.key.y) }
    var map = ""

    for y in (0...maxY-minY).reversed() {
        var row = ""
        for x in 0...maxX - minX {
            let dx = x + minX
            let dy = y + minY
            let value = output[Point(x: dx, y: dy)] ?? 0
            let char = tileMap[value]!
            row += char
        }
        map += row + "\n"
    }
    // hKthH7kh
    print(map + "\n")
}
