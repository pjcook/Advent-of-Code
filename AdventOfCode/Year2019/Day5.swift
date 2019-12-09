//
//  Day5.swift
//  Year2019
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

struct AdvancedIntCodeComputer {
    struct Program {
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
            
            var instructionCount: Int {
                switch self {
                case .add, .multiply, .lessThan, .equals: return 4
                case .input, .output, .adjustRelativeBase: return 2
                case .jumpIfFalse, .jumpIfTrue: return 3
                case .finished: return 0
                }
            }
        }
        
        enum Mode: Int {
            case position = 0
            case immediate = 1
            case relative = 2
        }
        
        let opCode: OpCode
        let value: Int?
        let output: Int?
        let writeIndex: Int?
        let position: Int
        let relativeBase: Int
        
        init(readData: (Int)->Int, readInput: ()->Int, position: Int, relativeBase: Int = 0, forceWriteMode: Bool = true) throws {
            var string = String(readData(position))
            let e = string.count > 0 ? String(string.removeLast()) : ""
            let d = string.count > 0 ? String(string.removeLast()) : ""
            let c = string.count > 0 ? String(string.removeLast()) : ""
            let b = string.count > 0 ? String(string.removeLast()) : ""
            let a = string.count > 0 ? String(string.removeLast()) : ""
            
            guard
                let mode3 = Mode(rawValue: Int(a) ?? 0),
                let mode2 = Mode(rawValue: Int(b) ?? 0),
                let mode1 = Mode(rawValue: Int(c) ?? 0),
                let code = OpCode(rawValue: Int(d+e) ?? -999)
            else {
                throw Errors.invalidOpCode
            }
            
            opCode = code
            let param2Mode = mode2
            let param1Mode = mode1
            let writeMode = forceWriteMode ? .position : mode3
            
            switch opCode {
                case .add:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    writeIndex = Program.writePosition(readData: readData, position: position+3, relativeBase: relativeBase, mode: writeMode)
                    value = value1 + value2
                    output = nil
                    self.relativeBase = relativeBase

                case .multiply:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    writeIndex = Program.writePosition(readData: readData, position: position+3, relativeBase: relativeBase, mode: writeMode)
                    value = value1 * value2
                    output = nil
                    self.relativeBase = relativeBase

                case .input:
                    writeIndex = Program.writePosition(readData: readData, position: position+3, relativeBase: relativeBase, mode: writeMode)
                    value = readInput()
                    
                    output = nil
                    self.relativeBase = relativeBase

                case .output:
                    output = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    value = nil
                    writeIndex = nil
                    self.relativeBase = relativeBase
                    
                case .jumpIfTrue:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    if value1 != 0 {
                        writeIndex = value2
                    } else {
                        writeIndex = position + 3
                    }
                    value = nil
                    output = nil
                    self.relativeBase = relativeBase
                    
                case .jumpIfFalse:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    if value1 == 0 {
                        writeIndex = value2
                    } else {
                        writeIndex = position + 3
                    }
                    value = nil
                    output = nil
                    self.relativeBase = relativeBase
                    
                case .lessThan:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    writeIndex = Program.writePosition(readData: readData, position: position+3, relativeBase: relativeBase, mode: writeMode)
                    value = value1 < value2 ? 1 : 0
                    output = nil
                    self.relativeBase = relativeBase

                case .equals:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    let value2 = Program.read(readData: readData, position: position+2, relativeBase: relativeBase, mode: param2Mode)
                    writeIndex = Program.writePosition(readData: readData, position: position+3, relativeBase: relativeBase, mode: writeMode)
                    value = value1 == value2 ? 1 : 0
                    output = nil
                    self.relativeBase = relativeBase
                
                case .adjustRelativeBase:
                    let value1 = Program.read(readData: readData, position: position+1, relativeBase: relativeBase, mode: param1Mode)
                    self.relativeBase = relativeBase + value1
                    writeIndex = nil
                    output = nil
                    value = nil

                case .finished:
                    writeIndex = nil
                    value = nil
                    output = nil
                    self.relativeBase = relativeBase
            }
            
            self.position = Program.incrementPosition(position, opCode: opCode, writeIndex: writeIndex)
        }
        
        private static func writePosition(readData: (Int)->Int, position: Int, relativeBase: Int, mode: Mode) -> Int {
            switch mode {
            case .immediate: return position
            case .position: return readData(position)
            case .relative: return relativeBase + readData(position)
            }
        }
        
        private static func read(readData: (Int)->Int, position: Int, relativeBase: Int, mode: Mode) -> Int {
            switch mode {
            case .immediate: return readData(position)
            case .position: return readData(readData(position))
            case .relative: return readData(relativeBase + readData(position))
            }
        }
        
        private static func incrementPosition(_ position: Int, opCode: OpCode, writeIndex: Int?) -> Int {
            switch opCode {
            case .jumpIfTrue, .jumpIfFalse:
                return writeIndex ?? 0
                
            default:
                return position + opCode.instructionCount
            }
        }
    }

    private var data: [Int]
    var readData: [Int] { return data }
    
    init(data: [Int]) {
        self.data = data
    }
    
    mutating func process(_ readInput: ()->Int, processOutput: ((Int)->())? = nil, finished: (()->Void)? = nil, forceWriteMode: Bool = true) throws -> Int {
        guard !data.isEmpty else { throw Errors.intCodeNoData }
        func readData(index: Int) -> Int {
            return data[index]
        }
        var position = 0
        var output = -1
        let dataCount = data.count
        var program = try Program(readData: readData, readInput: readInput, position: position, forceWriteMode: forceWriteMode)
        while program.opCode != .finished {
            if let writeIndex = program.writeIndex, let value = program.value {
                data[writeIndex] = value
            } else if let programOutput = program.output {
                output = programOutput
                processOutput?(output)
            }
            
            position = program.position

            guard position < dataCount else { throw Errors.intCodeInvalidIndex }
            program = try Program(readData: readData, readInput: readInput, position: position, relativeBase: program.relativeBase, forceWriteMode: forceWriteMode)
        }
        finished?()
        return output
    }
}
