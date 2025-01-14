//
//  Day11.swift
//  Year2019
//
//  Created by PJ COOK on 10/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

extension Direction {
    public func rotate(_ value: Int) -> Direction {
        if value == 0 { return rotateLeft() }
        return rotateRight()
    }

}

public func paintWithRobot(_ program: [Int], startColor: Int) -> Int {
    let bigProgram = program + Array(repeating: 0, count: 1000)
    let computer = AdvancedIntCodeComputer(data: bigProgram)
    var output = [Point.zero:startColor]
    var rawData = [Int]()
    var position = Point.zero
    var color = startColor
    var direction = Direction.up
    var hasOutputColor = false
    _ = computer.process({
        output[position, default: 0]
    }, processOutput: {
        rawData.append($0)
        if hasOutputColor {
            direction = direction.rotate($0)
            output[position] = color
            position = position + direction.point
            hasOutputColor = false
        } else {
            color = $0
            hasOutputColor = true
        }
    }, finished: nil, forceWriteMode: false)
        
//    drawShipRegistration(output)
    
    return output.count
}

public func drawShipRegistration(_ output: [Point:Int]) {
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
            let value = output[Point(x: dx, y: dy), default: 0]
            if value == 1 { row += "⚪️" }
            else { row += "⚫️" }
        }
        map += row + "\n"
    }
    // hKthH7kh
    print(map + "\n")
}
