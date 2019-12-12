//
//  SteppedIntComputer.swift
//  Year2019
//
//  Created by PJ COOK on 11/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

class SteppedIntComputer {
    typealias ReadInput = ()->Int?
    typealias ProcessOutput = (Int)->Void
    typealias CompletionHandler = ()->Void
    
    enum State {
        case waiting
        case waitingForInput
        case running
        case finished
    }
    
    private var data: [Int]
    private(set) var state = State.waiting
    private var instructionIndex = 0
    private let readInput: ReadInput
    private let processOutput: ProcessOutput
    private let completionHandler: CompletionHandler
    private let forceWriteMode: Bool
    
    init(
        data: [Int],
        readInput: @escaping ReadInput,
        processOutput: @escaping ProcessOutput,
        completionHandler: @escaping CompletionHandler,
        forceWriteMode: Bool
    ) {
        self.data = data
        self.readInput = readInput
        self.processOutput = processOutput
        self.completionHandler = completionHandler
        self.forceWriteMode = forceWriteMode
    }
    
    func process() {
        state = .running
        while state == .running {
            let instruction = Instruction(
                readData: readData,
                writeData: writeData,
                finished: finished,
                writeOutput: processOutput,
                readInput: {
                    if let input = readInput() {
                        return input
                    } else {
                        state = .waitingForInput
                        return nil
                    }
                },
                instructionIndex: instructionIndex,
                forceWriteMode: forceWriteMode
            )
            if state == .running {
                instructionIndex = instruction.instructionIndex
            }
        }
    }
}

extension SteppedIntComputer {
    private func readData(_ index: Int) -> Int {
        return data[index]
    }
    
    private func writeData(_ index: Int, _ value: Int) {
        data[index] = value
    }
    
    private func finished() {
        state = .finished
        completionHandler()
    }
}
