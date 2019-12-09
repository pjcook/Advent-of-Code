//
//  Day7.swift
//  Year2019
//
//  Created by PJ COOK on 07/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

func processThrusterSettings(_ settings: [Int], _ input: [Int]) throws -> Int {
    var programInputs = [0]
    
    func readInput() -> Int {
        programInputs.removeFirst()
    }
    
    var output = 0
    
    for setting in settings {
        print("Running Amplifier:\(setting)")
        let amp = AdvancedIntCodeComputer(data: input)
        programInputs = [setting, output]
        output = try amp.process(readInput, processOutput: { print("Output:\($0)") })
    }

    return output
}

class ChainedComputer {
    private let program: [Int]
    private var inputs: [Int]
    private var amplifier: AdvancedIntCodeComputer
    private let id: String
    
    var lastOutput: Int?
    var shouldStopProcessing = false
    
    deinit {
        shouldStopProcessing = true
    }
    
    init(id: String, inputs: [Int], program: [Int]) {
        self.id = id
        self.program = program
        self.inputs = inputs
        amplifier = AdvancedIntCodeComputer(data: program)
    }
    
    func run(writeInput: ((Int)->Void)?) throws {
        shouldStopProcessing = false
        lastOutput = try amplifier.process(readInput, processOutput: { input in
            writeInput?(input)
        }, finished: finished)
    }
    
    private func readInput() -> Int {
        guard !shouldStopProcessing else { return 0 }
        usleep(200)
        if inputs.isEmpty {
            return readInput()
        }
        return inputs.removeFirst()
    }
    
    func writeInput(_ input: Int) {
        inputs.append(input)
    }
    
    private func finished() {
        shouldStopProcessing = true
    }
}

func processThrusterSettingsLooped(_ settings: [Int], _ input: [Int]) throws -> Int {
    let completeGroup = DispatchGroup()

    let computer1 = ChainedComputer(id: "1", inputs: [settings[0], 0], program: input)
    let computer2 = ChainedComputer(id: "2", inputs: [settings[1]], program: input)
    let computer3 = ChainedComputer(id: "3", inputs: [settings[2]], program: input)
    let computer4 = ChainedComputer(id: "4", inputs: [settings[3]], program: input)
    let computer5 = ChainedComputer(id: "5", inputs: [settings[4]], program: input)
    
    DispatchQueue.global().async {
        completeGroup.enter()
        do {
            try computer1.run(writeInput: computer2.writeInput)
        } catch {}
        completeGroup.leave()
    }
    
    DispatchQueue.global().async {
        completeGroup.enter()
        do {
            try computer2.run(writeInput: computer3.writeInput)
        } catch {}
        completeGroup.leave()
    }
    
    DispatchQueue.global().async {
        completeGroup.enter()
        do {
            try computer3.run(writeInput: computer4.writeInput)
        } catch {}
        completeGroup.leave()
    }
    
    DispatchQueue.global().async {
        completeGroup.enter()
        do {
            try computer4.run(writeInput: computer5.writeInput)
        } catch {}
        completeGroup.leave()
    }
    
    var finalOutput = 0
    completeGroup.enter()

    DispatchQueue.global().async {
        do {
            try computer5.run(writeInput: computer1.writeInput)
            finalOutput = computer5.lastOutput!
            completeGroup.leave()
        } catch {
            completeGroup.leave()
        }
    }
    
    completeGroup.wait()
    return finalOutput
}

func generateCombinations(_ possibleValues: [Int]) -> [[Int]] {
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

func findMaximumThrusterValue(phaseSettings: [Int], input: [Int], loop: Bool = false) throws -> Int {
    var maxValue = 0
    
    for combination in generateCombinations(phaseSettings) {
        if loop {
            maxValue = max(try processThrusterSettingsLooped(combination, input), maxValue)
        } else {
            maxValue = max(try processThrusterSettings(combination, input), maxValue)
        }
    }
    
    return maxValue
}
