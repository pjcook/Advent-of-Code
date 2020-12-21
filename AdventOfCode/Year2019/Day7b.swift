//
//  Day7b.swift
//  Year2019
//
//  Created by PJ COOK on 13/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

func processAmplifiersLooped(_ settings: [Int], _ input: [Int]) throws -> Int {
    var orderedAmplifiers = [SteppedIntComputer]()
    var amplifiers = [SteppedIntComputer:[Int]]()
    var finished = false
    var lastOutput = 0
    
    func readInput(index: Int) -> Int? {
        var inputs = amplifiers[orderedAmplifiers[index], default: []]
        guard !inputs.isEmpty else { return nil }
        let input = inputs.removeFirst()
        amplifiers[orderedAmplifiers[index]] = inputs
        return input
    }
    
    func processOutput(value: Int, index: Int) {
        let newIndex = index+1 < settings.count ? index+1 : 0
        var inputs = amplifiers[orderedAmplifiers[newIndex], default: []]
        inputs.append(value)
        amplifiers[orderedAmplifiers[newIndex]] = inputs
        lastOutput = value
//        print(index, inputs)
    }
    
    func completionHandler(index: Int) {
//        print(index, "finished")
        if index == settings.count-1 {
            finished = true
        }
    }
    
    for i in 0..<settings.count {
        let amp = SteppedIntComputer(
            id: i,
            data: input,
            readInput: { return readInput(index: i) },
            processOutput: { processOutput(value: $0, index: i) },
            completionHandler: { completionHandler(index: i) },
            forceWriteMode: true
        )
        if i == 0 {
            amplifiers[amp] = [settings[i], 0]
        } else {
            amplifiers[amp] = [settings[i]]
        }
        orderedAmplifiers.append(amp)
    }
    
    var ampPointer = 0
    while !finished {
        let amp = orderedAmplifiers[ampPointer]
        amp.process()
        while amp.state == .running {
            amp.process()
        }
        ampPointer = ampPointer+1 < orderedAmplifiers.count ? ampPointer+1 : 0
    }
    
    return lastOutput
}
