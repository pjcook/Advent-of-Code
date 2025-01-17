//
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader
import StandardLibraries

public final class Day7 {
    public init() {}
    private var inputs = [Int: [Int]]()
    private var output = 0
    private var finished = false
    private var computerID = 0

    public func part1(_ input: [Int], settings: [Int]) -> Int {
        let computer = Computer(id: 0, forceWriteMode: true)
        computer.delegate = self
        
        var maxValue = 0
        
        for combination in generateCombinations(settings) {
            maxValue = max(maxValue, attemptSequence(input, computer: computer, sequence: combination))
        }
        
        return maxValue
    }
    
    public func part2(_ input: [Int], settings: [Int]) -> Int {
        var computers = [Computer]()
        for i in 0..<5 {
            let computer = Computer(id: i, forceWriteMode: true)
            computer.loadProgram(input)
            computer.delegate = self
            computers.append(computer)
        }

        var maxValue = 0
        
        for combination in generateCombinations(settings) {
            computers.forEach {
                $0.loadProgram(input)
                $0.reset()
            }
            maxValue = max(maxValue, attemptSequenceLooped(computers: computers, sequence: combination))
        }
        
        return maxValue
    }
    
    private func attemptSequence(_ input: [Int], computer: Computer, sequence: [Int]) -> Int {
        var sequence = sequence
        output = 0
        inputs = [:]
        computerID = 0
        finished = false

        while !sequence.isEmpty {
            computer.loadProgram(input)
            computer.reset()
            let phaseSetting = sequence.removeFirst()
            var list = inputs[0, default: []]
            list.append(phaseSetting)
            list.append(output)
            inputs[0] = list
            
            while !computer.isFinished {
                computer.tick()
            }
            computerID += 1
            if computerID == 5 { computerID = 0 }
        }
        
        return output
    }
    
    private func attemptSequenceLooped(computers: [Computer], sequence: [Int]) -> Int {
        inputs = [:]
        output = 0
        computerID = 0
        finished = false
        
        for i in 0..<5 {
            inputs[i] = [sequence[i]]
        }
        var list = inputs[0, default: []]
        list.append(0)
        inputs[0] = list

        while !finished {
            while !computers[computerID].isFinished {
                computers[computerID].tick()
            }
            computerID += 1
            if computerID == 5 { computerID = 0 }
        }
        
        return output
    }
}

extension Day7: ComputerDelegate {
    public func processOutput(id: Int, value: Int) {
        output = value
        var computerID = id + 1
        if computerID == 5 { computerID = 0 }
        var list = inputs[computerID, default: []]
        list.append(value)
        inputs[computerID] = list
        self.computerID = computerID
    }
    
    public func readInput(id: Int) -> Int {
        if inputs[id, default: []].isEmpty { return -1 }
        var list = inputs[id]!
        let value = list.removeFirst()
        inputs[id] = list
        return value
    }
    
    public func computerFinished(id: Int) {
        if id == 4 {
            finished = true
        }
    }
}

public func generateCombinations(_ possibleValues: [Int]) -> [[Int]] {
    var combinations = [[Int]]()

    for value in possibleValues {
        let options = possibleValues.compactMap { $0 != value ? $0 : nil }
        if options.count == 1 {
            combinations.append([value, options.first!])
        } else {
            let sequences = generateCombinations(options)
            for sequence in sequences {
                combinations.append([value]+sequence)
            }
        }
    }
    
    
    return combinations
}
