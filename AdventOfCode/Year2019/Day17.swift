//
//  Day17.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

class VacuumRobot {
    private var computer: SteppedIntComputer?
    private let tiles = [35:"🟤", 46:"⚫️", 10:"⚪️", 65:"A", 66:"B", 67:"C", 82:"R", 76:"L", 94:"🔼", 118:"🔽", 60:"◀️", 62:"▶️", 401:"⚪️"]
    var map: [Point:CalibrationInput] = [:]
    var position = Point.zero
    var collectedDust = 0
    
    enum CalibrationInput: Int {
        case scaffold = 35  // #
        case empty = 46     // .
        case newLine = 10   // newline
        case A = 65         // A
        case B = 66         // B
        case C = 67         // C
        case R = 82         // R
        case L = 76         // L
        case up = 94        // ^
        case down = 118     // v
        case left = 60      // <
        case right = 62     // >
        case visited = 401
    }

    init(_ input: [Int]) {
        computer = SteppedIntComputer(
            id: 6,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: {
                self.drawMapInConsole()
                print("Finished")
            },
            forceWriteMode: false
        )
    }
    
    func calibrate() -> Int {
        computer?.process()
        let points = findIntersects()
        return sumIntersects(points)
    }
    
    func sumIntersects(_ points: [Point]) -> Int {
        return points.reduce(0) { $0 + ($1.x * $1.y) }
    }
    
    func findIntersects() -> [Point] {
        return map.filter { isIntersectPoint($0.key) }.map { $0.key }
    }
    
    func isIntersectPoint(_ point: Point) -> Bool {
        var count = 0
        count += (map[point + Direction.N.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.S.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.E.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.W.point] ?? .empty) == .scaffold ? 1 : 0
        return count == 4
    }

    var inputPointer = 0
    var inputInstructions = [Int]()
    
    func populateInstructions(_ input: String) {
        inputInstructions = input.toAscii()
        inputPointer = 0
    }
    
    var storeOutput = false
    var storedOutput = ""
    
    private func readInput() -> Int {
//        if !storeOutput {
//            print(findStartPoint())
//            drawMapInConsole()
//        }
        let input = inputInstructions[inputPointer]
        inputPointer += 1
//        print(inputPointer, input.fromAscii())
        storeOutput = true
        return input
        
    }
    
    private func findStartPoint() -> (Point, Direction) {
        let tile = map.first { [.up, .down, .left, .right].contains($0.value) }!
    
        if tile.value == .up { return (tile.key, Direction.N) }
        else if tile.value == .down { return (tile.key, Direction.S) }
        else if tile.value == .left { return (tile.key, Direction.W) }
        else { return (tile.key, Direction.E) }
        
    }
    
    private func processOutput(_ value: Int) {
        if value > 32000 {
            collectedDust = value
            return
        }
        guard let status = CalibrationInput(rawValue: value) else {
            if value > 0, let us = value.toAscii() {
                storedOutput += us
            } else if value > 127 {
                print("Invalid value:", value)
            }
            return
        }
        switch status {
            case .newLine:
                if storeOutput {
                    print(storedOutput)
                    storedOutput = ""
                } else {
                    position = Point(x: 0, y: position.y+1)
                }
            default:
                if storeOutput {
                    storedOutput += value.toAscii()!
                } else {
                    map[position] = status
                    position = Point(x: position.x+1, y: position.y)
                }
        }
//        print("Output:", status, value, position)
    }
    
    func drawMapInConsole() {
        var rawMap = [Point:Int]()
        _ = map.map { rawMap[$0] = $1.rawValue }
        drawMap(rawMap, tileMap: tiles)
    }
}

