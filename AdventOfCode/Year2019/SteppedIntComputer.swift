//
//  SteppedIntComputer.swift
//  Year2019
//
//  Created by PJ COOK on 11/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

class SteppedIntComputer: Hashable {
    typealias ReadInput = ()->Int?
    typealias ProcessOutput = (Int)->Void
    typealias CompletionHandler = ()->Void
    
    enum State {
        case waiting
        case waitingForInput
        case running
        case finished
    }
    
    let id: Int
    private var data: [Int:Int]
    private(set) var state = State.waiting
    private var instructionIndex = 0
    private var relativeBase = 0
    private let readInput: ReadInput
    private let processOutput: ProcessOutput
    private let completionHandler: CompletionHandler
    private let forceWriteMode: Bool
    
    init(
        id: Int,
        data: [Int],
        readInput: @escaping ReadInput,
        processOutput: @escaping ProcessOutput,
        completionHandler: @escaping CompletionHandler,
        forceWriteMode: Bool
    ) {
        var dataToDict = [Int:Int]()
        for i in 0..<data.count {
            dataToDict[i] = data[i]
        }
        self.id = id
        self.data = dataToDict
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
                readInput: manageReadInput,
                instructionIndex: instructionIndex,
                relativeBase: relativeBase,
                forceWriteMode: forceWriteMode
            )
            if state == .running {
                instructionIndex = instruction.instructionIndex
                relativeBase = instruction.relativeBase
            }
        }
    }
    
    private func manageReadInput() -> Int? {
        if let input = readInput() {
            return input
        } else {
            state = .waitingForInput
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SteppedIntComputer, rhs: SteppedIntComputer) -> Bool {
        lhs.id == rhs.id
    }
}

extension SteppedIntComputer {
    private func readData(_ index: Int) -> Int {
        return data[index] ?? 0
    }
    
    private func writeData(_ index: Int, _ value: Int) {
        data[index] = value
    }
    
    private func finished() {
        state = .finished
        completionHandler()
    }
}
