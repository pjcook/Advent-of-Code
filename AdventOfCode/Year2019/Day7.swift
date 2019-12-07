//
//  Day7.swift
//  Year2019
//
//  Created by PJ COOK on 07/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

func processThrusterSettings(_ settings: [Int], _ input: [Int], loop: Bool = false) throws -> Int {
    var amp1 = AdvancedIntCodeComputer(data: input)
    var amp2 = AdvancedIntCodeComputer(data: input)
    var amp3 = AdvancedIntCodeComputer(data: input)
    var amp4 = AdvancedIntCodeComputer(data: input)
    var amp5 = AdvancedIntCodeComputer(data: input)
    
    var programInputs = [Int]()
    
    func readInput() -> Int {
        let value = programInputs.removeFirst()
        if programInputs.isEmpty {
            programInputs.append(value)
        }
        return value
    }
    
    
    
    programInputs = [settings[0], 0]
    let a = try amp1.process(readInput)
    
    programInputs = [settings[1], a]
    let b = try amp2.process(readInput)
    
    programInputs = [settings[2], b]
    let c = try amp3.process(readInput)
    
    programInputs = [settings[3], c]
    let d = try amp4.process(readInput)
    
    programInputs = [settings[4], d]
    return try amp5.process(readInput)
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

func findMaximumThrusterValue(phaseSettings: [Int]) throws -> Int {
    guard let input = try readInput(filename: "Day7.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }

    var maxValue = 0
    
    for combination in generateCombinations(phaseSettings) {
        maxValue = max(try processThrusterSettings(combination, input), maxValue)
    }
    
    return maxValue
}
