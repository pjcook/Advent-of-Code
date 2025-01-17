//
//  Day23.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

public final class Day23 {
    public init() {}
    private var x = 0
    private var y = 0
    private var isPart1 = true
    private var computers = [Int: (Computer, [Int], [Int])]()
    public var output: Int?
    public var runningComputers = 0

    public func part1(_ input: [Int], isPart1: Bool) -> Int {
        self.isPart1 = isPart1
        computers.removeAll()
        (0...49).forEach {
            let computer = Computer(id: $0, forceWriteMode: false)
            computers[$0] = (computer, [$0], [])
            computer.loadProgram(input)
            computer.delegate = self
        }
        runningComputers = computers.count
        
        while runningComputers > 0 {
            for (computer, _, _) in computers.values {
                computer.tick()
            }
        }
        
        return output ?? -1
    }
    
    func stopComputers() {
        for (computer, _, _) in computers.values {
            computer.stop()
        }
    }
    
    func isIdleNetwork() -> Bool {
        guard idleComputers.count == computers.count else { return false }
        return idleComputers.reduce(0) { $0 + ($1.value > 1 ? 1 : 0) } == computers.count
    }
    
    private var lastNatMessageValue: Int?
    func nudgeNat() {
        if lastNatMessageValue == y {
            output = y
            stopComputers()
        } else {
            lastNatMessageValue = y
            sendMessage(id: 0, x: x, y: y)
        }
    }
    
    private var idleComputers = [Int: Int]()
    func computerIdle(id: Int) {
        guard y != 0 else { return }
        idleComputers[id] = idleComputers[id, default: 0] + 1
        if isIdleNetwork() {
            nudgeNat()
            idleComputers.removeAll()
        }
    }
    
    func computerNotIdle(id: Int) {
        idleComputers[id] = nil
    }
}

extension Day23: ComputerDelegate {
    public func sendMessage(id: Int, x: Int, y: Int) {
        if isPart1 && id == 255 {
            output = y
            stopComputers()
        } else if !isPart1 && id == 255 {
            self.x = x
            self.y = y
        }
        guard let (computer, inputs, outputs) = computers[id] else { return }
        computers[id] = (computer, inputs + [x, y], outputs)
    }
    
    public func processOutput(id: Int, value: Int) {
        guard let (computer, inputs, outputs) = computers[id] else { return }
        if outputs.count == 2 {
            computers[id] = (computer, inputs, [])
            sendMessage(id: outputs[0], x: outputs[1], y: value)
        } else {
            computers[id] = (computer, inputs, outputs + [value])
        }
    }
    
    public func readInput(id: Int) -> Int {
        guard let (computer, inputs, outputs) = computers[id], !inputs.isEmpty else {
            computerIdle(id: id)
            return -1
        }
        var inputs2 = inputs
        computerNotIdle(id: id)
        let value = inputs2.removeFirst()
        computers[id] = (computer, inputs2, outputs)
        return value
    }
    
    public func computerFinished(id: Int) {
        runningComputers -= 1
    }
}
