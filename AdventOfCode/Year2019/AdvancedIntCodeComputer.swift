//
//  Day5.swift
//  Year2019
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

class AdvancedIntCodeComputer {
    private var data: [Int]
    var readData: [Int] { return data }
    
    init(data: [Int]) {
        self.data = data
    }
    
    private func readData(_ index: Int) -> Int {
        return data[index]
    }
    
    private func writeData(_ index: Int, _ value: Int) {
        data[index] = value
    }
    
    func process(_ readInput: ()->Int, processOutput: ((Int)->())? = nil, finished: (()->Void)? = nil, forceWriteMode: Bool = true) -> Int {
        
        var instructionIndex = 0
        var output = -1
        
        func writeOutput(_ value: Int) {
            output = value
            processOutput?(output)
        }
//        print(data)
        var instruction = Instruction(
            readData: readData,
            writeData: writeData,
            finished: {},
            writeOutput: writeOutput,
            readInput: readInput,
            instructionIndex: instructionIndex,
            forceWriteMode: forceWriteMode
        )
//        print(data)
        while instruction.opCode != .finished {
//            print(data)
            instructionIndex = instruction.instructionIndex
            instruction = Instruction(
                readData: readData,
                writeData: writeData,
                finished: {},
                writeOutput: writeOutput,
                readInput: readInput,
                instructionIndex: instructionIndex,
                relativeBase: instruction.relativeBase,
                forceWriteMode: forceWriteMode
            )
        }
        finished?()
        return output
    }
}

struct Instruction {
    enum OpCode: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
        case finished = 99
        
        func incrementPosition(_ instructionIndex: Int) -> Int {
            switch self {
            case .jumpIfTrue, .jumpIfFalse: return instructionIndex
            case .add, .multiply, .lessThan, .equals: return instructionIndex + 4
            case .input, .output, .adjustRelativeBase: return instructionIndex + 2
            case .finished: return instructionIndex
            }
        }
    }
    
    enum Mode: Int {
        case instructionIndex = 0
        case immediate = 1
        case relative = 2
    }
    
    let opCode: OpCode
    let instructionIndex: Int
    let relativeBase: Int
    
    init(
        readData: (Int)->Int,
        writeData: (Int, Int)->Void,
        finished: ()->Void,
        writeOutput: (Int)->Void,
        readInput: ()->Int?,
        instructionIndex: Int,
        relativeBase: Int = 0,
        forceWriteMode: Bool = true
    ) {
        var instructionIndex = instructionIndex
        let instruction = readData(instructionIndex)
        let d = instruction % 100
        let c = instruction % 10000 % 1000 / 100
        let b = instruction % 10000 / 1000
        let a = instruction / 10000
        
        guard
            let mode3 = Mode(rawValue: a),
            let mode2 = Mode(rawValue: b),
            let mode1 = Mode(rawValue: c),
            let code = OpCode(rawValue: d)
        else {
            opCode = .finished
            self.instructionIndex = instructionIndex
            self.relativeBase = relativeBase
            return
        }
        
        opCode = code
        let param2Mode = mode2
        let param1Mode = mode1
        let writeMode = forceWriteMode ? .instructionIndex : mode3
        
        switch opCode {
            case .add:
                let (value1, value2, writeIndex) =
                    Instruction.readThreeValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode, writeMode: writeMode)
                writeData(writeIndex, value1 + value2)
                self.relativeBase = relativeBase

            case .multiply:
                let (value1, value2, writeIndex) =
                    Instruction.readThreeValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode, writeMode: writeMode)
                writeData(writeIndex, value1 * value2)
                self.relativeBase = relativeBase

            case .input:
                let writeIndex = Instruction.writePosition(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase, mode: param1Mode)
                if let input = readInput() {
                    writeData(writeIndex, input)
                }
                self.relativeBase = relativeBase

            case .output:
                let output = Instruction.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase, mode: param1Mode)
                writeOutput(output)
                self.relativeBase = relativeBase
                
            case .jumpIfTrue:
                let (value1, value2) =
                    Instruction.readTwoValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode)
                instructionIndex = value1 != 0 ? value2 : instructionIndex + 3
                self.relativeBase = relativeBase
                
            case .jumpIfFalse:
                let (value1, value2) =
                    Instruction.readTwoValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode)
                instructionIndex = value1 == 0 ? value2 : instructionIndex + 3
                self.relativeBase = relativeBase
                
            case .lessThan:
                let (value1, value2, writeIndex) =
                    Instruction.readThreeValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode, writeMode: writeMode)
                writeData(writeIndex, value1 < value2 ? 1 : 0)
                self.relativeBase = relativeBase

            case .equals:
                let (value1, value2, writeIndex) =
                    Instruction.readThreeValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, param1Mode: param1Mode, param2Mode: param2Mode, writeMode: writeMode)
                writeData(writeIndex, value1 == value2 ? 1 : 0)
                self.relativeBase = relativeBase
            
            case .adjustRelativeBase:
                let value1 = Instruction.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase, mode: param1Mode)
                self.relativeBase = relativeBase + value1

            case .finished:
                finished()
                self.relativeBase = relativeBase
        }
        
        self.instructionIndex = opCode.incrementPosition(instructionIndex)
    }
    
    private static func readTwoValues(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int, param1Mode: Mode, param2Mode: Mode) -> (Int,Int) {
        (
            Instruction.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase, mode: param1Mode),
            Instruction.read(readData: readData, instructionIndex: instructionIndex+2, relativeBase: relativeBase, mode: param2Mode)
        )
    }
    
    private static func readThreeValues(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int, param1Mode: Mode, param2Mode: Mode, writeMode: Mode) -> (Int,Int,Int) {
        return (
            Instruction.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase, mode: param1Mode),
            Instruction.read(readData: readData, instructionIndex: instructionIndex+2, relativeBase: relativeBase, mode: param2Mode),
            Instruction.writePosition(readData: readData, instructionIndex: instructionIndex+3, relativeBase: relativeBase, mode: writeMode)
        )
    }
    
    private static func writePosition(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int, mode: Mode) -> Int {
        switch mode {
        case .immediate: return instructionIndex
        case .instructionIndex: return readData(instructionIndex)
        case .relative: return relativeBase + readData(instructionIndex)
        }
    }
    
    private static func read(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int, mode: Mode) -> Int {
        switch mode {
        case .immediate: return readData(instructionIndex)
        case .instructionIndex: return readData(readData(instructionIndex))
        case .relative: return readData(relativeBase + readData(instructionIndex))
        }
    }
}
