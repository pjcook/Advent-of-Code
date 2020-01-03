//
//  Day19.swift
//  Year2019
//
//  Created by PJ COOK on 18/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct GridSize {
    let width: Int
    let height: Int
}

class TractorBeamAnalyser {
    private var inputs: [Int] = []
    private var outputs: [Point: Int] = [:]
    private var position = Point.zero
    private var lastX = 0
    private let size: GridSize
    private let input: [Int]
    
    init(input: [Int], size: GridSize) {
        self.size = size
        self.input = input
    }
    
    enum HorizontalTractorState {
        case looking, found
    }
    var state: HorizontalTractorState = .looking

    func calculate() -> Int {
        position = Point.zero
        inputs = [position.x,position.y]
        outputs = [:]
        state = .looking
        
        repeat {
            processPosition()
        } while !hasFinishedPart1()
        
        return outputs.reduce(0) { $0 + $1.value }
    }
    
    func printGridFor(_ size: GridSize, startPosition: Point) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                _ = checkPosition(Point(x: x+startPosition.x, y: y+startPosition.y))
            }
        }
        drawOutputs()
    }
    
    func findTractorDistance(_ size: GridSize, startPosition: Point) -> Int {
        position = startPosition
        inputs = [position.x,position.y]
        outputs = [:]
        state = .looking
        var finished = false
        
        while !finished {
            let value = checkPosition(position)
            switch state {
            case .looking:
                if value == 1 {
                    state = .found
                    lastX = position.x
                } else {
                    incrementPosition()
                }
                
            case .found:
                if value == 0 {
                    state = .looking
                    movePositionToNextLine()
                } else {
                    incrementPosition()
                }
            }
            
            guard state == .found else { continue }
            
            let topRight = position.addX(size.width)
            guard checkPosition(topRight) == 1 else {
                state = .looking
                movePositionToNextLine()
                continue
            }
            
            let bottomLeft = position.addY(size.height)
            if checkPosition(bottomLeft) == 1 {
                finished = true
            }
        }
                
        return position.x * 10000 + position.y
    }
    
    func drawOutputs() {
        drawMap(outputs, tileMap: [0: "⚫️", 1: "🟣"], filename: "Day19.output")
    }
    
    func checkPosition(_ point: Point) -> Int {
        if let value = outputs[point] {
            return value
        }
        
        inputs = [point.x, point.y]
        var value = 0
        let computer = SteppedIntComputer(
            id: 6,
            data: input,
            readInput: readInput,
            processOutput: {
                value = $0
            },
            completionHandler: {},
            forceWriteMode: false
        )
        computer.process()
        outputs[point] = value
        return value
    }
    
    private func readInput() -> Int {
        return inputs.removeFirst()
    }
        
    private func processOutput(_ value: Int) {
        outputs[position] = value
    }
    
    private func processPosition() {
        let computer = SteppedIntComputer(
            id: 6,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: {},
            forceWriteMode: false
        )
        computer.process()
    }
    
    private func hasFinishedPart1() -> Bool {
        guard let value = outputs[position] else { return true }
        
        switch state {
        case .looking:
            if value == 1 {
                state = .found
                lastX = position.x
            }
            incrementPosition()
            
        case .found:
            if value == 0 {
                state = .looking
                movePositionToNextLine()
            } else {
                incrementPosition()
            }
        }
        inputs.append(position.x)
        inputs.append(position.y)
        return position.y >= size.height
    }
    
    private func incrementPosition() {
        if position.x < size.width-1 {
            position = Point(x: position.x + 1, y: position.y)
        } else {
            movePositionToNextLine()
        }
    }
    
    private func movePositionToNextLine() {
        position = Point(x: lastX, y: position.y + 1)
    }
}

