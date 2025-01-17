//
//  Day5.swift
//  Year2019
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

public class AdvancedIntCodeComputer {
    private var data: [Int]
    public var readData: [Int] { return data }
    
    public init(data: [Int]) {
        self.data = data
    }
    
    private func readData(_ index: Int) -> Int {
        return data[index]
    }
    
    private func writeData(_ index: Int, _ value: Int) {
        data[index] = value
    }
    
    public func process(_ readInput: ()->Int, processOutput: ((Int)->())? = nil, finished: (()->Void)? = nil, forceWriteMode: Bool = true) -> Int {
        
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

public struct Instruction {
    public enum OpCode: Int {
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
        
        public func incrementPosition(_ instructionIndex: Int) -> Int {
            switch self {
            case .jumpIfTrue, .jumpIfFalse: return instructionIndex
            case .add, .multiply, .lessThan, .equals: return instructionIndex + 4
            case .input, .output, .adjustRelativeBase: return instructionIndex + 2
            case .finished: return instructionIndex
            }
        }
    }
    
    public enum Mode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
        
        func writePosition(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int) -> Int {
            switch self {
            case .immediate: instructionIndex
            case .position: readData(instructionIndex)
            case .relative: relativeBase + readData(instructionIndex)
            }
        }
        
        func read(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int) -> Int {
            switch self {
            case .immediate: readData(instructionIndex)
            case .position: readData(readData(instructionIndex))
            case .relative: readData(relativeBase + readData(instructionIndex))
            }
        }
    }
    
    public let opCode: OpCode
    public let instructionIndex: Int
    public let relativeBase: Int
    
    public init(
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
        let writeMode = forceWriteMode ? .position : mode3
        //        print(opCode, param1Mode, param2Mode, writeMode, readData(instructionIndex+1), readData(instructionIndex+2), readData(instructionIndex+3))
        switch opCode {
        case .add:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode, writeMode])
            writeData(values[2], values[0] + values[1])
            self.relativeBase = relativeBase
            
        case .multiply:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode, writeMode])
            writeData(values[2], values[0] * values[1])
            self.relativeBase = relativeBase
            
        case .input:
            let writeIndex = param1Mode.writePosition(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase)
            if let input = readInput() {
                writeData(writeIndex, input)
            }
            self.relativeBase = relativeBase
            
        case .output:
            let output = param1Mode.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase)
            writeOutput(output)
            self.relativeBase = relativeBase
            
        case .jumpIfTrue:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode])
            instructionIndex = values[0] != 0 ? values[1] : instructionIndex + 3
            self.relativeBase = relativeBase
            
        case .jumpIfFalse:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode])
            instructionIndex = values[0] == 0 ? values[1] : instructionIndex + 3
            self.relativeBase = relativeBase
            
        case .lessThan:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode, writeMode])
            writeData(values[2], values[0] < values[1] ? 1 : 0)
            self.relativeBase = relativeBase
            
        case .equals:
            let values =
            Instruction.readValues(readData: readData, instructionIndex: instructionIndex, relativeBase: relativeBase, modes: [param1Mode, param2Mode, writeMode])
            writeData(values[2], values[0] == values[1] ? 1 : 0)
            self.relativeBase = relativeBase
            
        case .adjustRelativeBase:
            let value1 = param1Mode.read(readData: readData, instructionIndex: instructionIndex+1, relativeBase: relativeBase)
            self.relativeBase = relativeBase + value1
            
        case .finished:
            self.relativeBase = relativeBase
            finished()
        }
        
        self.instructionIndex = opCode.incrementPosition(instructionIndex)
    }
    
    private static func readValues(readData: (Int)->Int, instructionIndex: Int, relativeBase: Int, modes: [Mode]) -> [Int] {
        modes.enumerated().map { index, value in
            switch index {
            case 2: value.writePosition(readData: readData, instructionIndex: instructionIndex+index+1, relativeBase: relativeBase)
            default: value.read(readData: readData, instructionIndex: instructionIndex+index+1, relativeBase: relativeBase)
            }
        }
    }
}
