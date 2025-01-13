//
//  Day17.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public class VacuumRobot {
    private var computer: SteppedIntComputer?
    private let tiles = [35:"🟤", 46:"⚫️", 10:"⚪️", 65:"A", 66:"B", 67:"C", 82:"R", 76:"L", 94:"🔼", 118:"🔽", 60:"◀️", 62:"▶️", 401:"⚪️"]
    public var map: [Point:CalibrationInput] = [:]
    public var position = Point.zero
    public var collectedDust = 0
    
    public enum CalibrationInput: Int {
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

    public init(_ input: [Int]) {
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
    
    public func calibrate() -> Int {
        computer?.process()
        let points = findIntersects()
        return sumIntersects(points)
    }
    
    public func sumIntersects(_ points: [Point]) -> Int {
        return points.reduce(0) { $0 + ($1.x * $1.y) }
    }
    
    public func findIntersects() -> [Point] {
        return map.filter { isIntersectPoint($0.key) }.map { $0.key }
    }
    
    public func isIntersectPoint(_ point: Point) -> Bool {
        var count = 0
        count += (map[point + Direction.up.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.down.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.right.point] ?? .empty) == .scaffold ? 1 : 0
        count += (map[point + Direction.left.point] ?? .empty) == .scaffold ? 1 : 0
        return count == 4
    }

    public var inputPointer = 0
    public var inputInstructions = [Int]()
    
    public func populateInstructions(_ input: String) {
        inputInstructions = input.toAscii()
        inputPointer = 0
    }
    
    public var storeOutput = false
    public var storedOutput = ""
    
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
    
        if tile.value == .up { return (tile.key, Direction.up) }
        else if tile.value == .down { return (tile.key, Direction.down) }
        else if tile.value == .left { return (tile.key, Direction.left) }
        else { return (tile.key, Direction.right) }
        
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
    
    public func drawMapInConsole() {
        var rawMap = [Point:Int]()
        _ = map.map { rawMap[$0] = $1.rawValue }
        drawMap(rawMap, tileMap: tiles)
    }
}

public func drawMap(_ output: [Point:Int], tileMap: [Int:String], filename: String? = nil) {
    let (minX,minY,maxX,maxY) = calculateMapDimensions(output)
    var map = ""

    for y in (0...maxY-minY) {
        writeMapRow(maxX, minX, y, minY, output, tileMap, &map)
    }
    
    writeMapToFile(filename, map)
    if filename == nil { print(map + "\n") }
}

public func drawMapReversed(_ output: [Point:Int], tileMap: [Int:String], filename: String? = nil) {
    let (minX,minY,maxX,maxY) = calculateMapDimensions(output)
    var map = ""

    for y in (0...maxY-minY).reversed() {
        writeMapRow(maxX, minX, y, minY, output, tileMap, &map)
    }
    
    writeMapToFile(filename, map)
    if filename == nil { print(map + "\n") }
}

public func writeMapRow(_ maxX: Int, _ minX: Int, _ y: Int, _ minY: Int, _ output: [Point : Int], _ tileMap: [Int : String], _ map: inout String) {
    var row = ""
    for x in 0...maxX - minX {
        let dx = x + minX
        let dy = y + minY
        let value = output[Point(x: dx, y: dy)] ?? -1
        let char = tileMap[value] ?? "(\(value.toAscii() ?? " ")"
        row += char
    }
    map += row + "\n"
}

public func writeMapToFile(_ filename: String?, _ map: String) {
    if let filename = filename {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try map.write(to: url, atomically: true, encoding: .utf8)
            print(url)
        } catch { print(error) }
    }
}

public func calculateMapDimensions(_ output: [Point:Int]) -> (Int,Int,Int,Int) {
    let minX = output.reduce(Int.max) { min($0,$1.key.x) }
    let minY = output.reduce(Int.max) { min($0,$1.key.y) }
    let maxX = output.reduce(0) { max($0,$1.key.x) }
    let maxY = output.reduce(0) { max($0,$1.key.y) }
    return (minX,minY,maxX,maxY)
}
