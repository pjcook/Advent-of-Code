//
//  Day11.swift
//  Year2019
//
//  Created by PJ COOK on 10/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day11 {
    private var position = Point.zero
    private var direction = Direction.up
    private var color = 0
    private var hasOutputColor = false
    private var finished = false
    private var output: [Point: Int] = [:]
    
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        color = 0
        hasOutputColor = false
        position = .zero
        direction = .up
        output = [Point.zero: color]
        
        while !finished {
            computer.tick()
        }
        
//        drawShipRegistration(output)
        
        return output.count
    }
    
    public func part2(_ input: [Int]) -> Int {
        let computer = Computer(forceWriteMode: false)
        computer.delegate = self
        computer.loadProgram(input)
        color = 1
        hasOutputColor = false
        position = .zero
        direction = .up
        output = [Point.zero: color]
        
        while !finished {
            computer.tick()
        }
        
        drawShipRegistration(output)
        
        return output.count
    }
}

extension Day11: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        output[position, default: 0]
    }
    
    public func computerFinished(id: Int) {
        finished = true
    }
    
    public func processOutput(id: Int, value: Int) {
        if hasOutputColor {
            direction = direction.rotate(value)
            output[position] = color
            position = position + direction.point
            hasOutputColor = false
        } else {
            color = value
            hasOutputColor = true
        }
    }
}

extension Direction {
    public func rotate(_ value: Int) -> Direction {
        if value == 0 { return rotateLeft() }
        return rotateRight()
    }
}

public func drawShipRegistration(_ output: [Point:Int]) {
    let minX = output.reduce(0) { min($0,$1.key.x) }
    let minY = output.reduce(0) { min($0,$1.key.y) }
    let maxX = output.reduce(0) { max($0,$1.key.x) }
    let maxY = output.reduce(0) { max($0,$1.key.y) }
    var map = ""

    for y in (0...maxY-minY) {
        var row = ""
        for x in 0...maxX - minX {
            let dx = x + minX
            let dy = y + minY
            let value = output[Point(x: dx, y: dy), default: 0]
            if value == 1 { row += "⚪️" }
            else { row += "⚫️" }
        }
        map += row + "\n"
    }
    // hKthH7kh
    print(map + "\n")
}
