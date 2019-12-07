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
            case finished = 99
            
            var instructionCount: Int {
                switch self {
                case .add, .multiply, .lessThan, .equals: return 4
                case .input, .output: return 2
                case .jumpIfFalse, .jumpIfTrue: return 3
                case .finished: return 0
                }
            }
        }
        
        enum Mode: Int {
            case position = 0
            case immediate = 1
        }
        
        let opCode: OpCode
        let value: Int?
        let output: Int?
        let writeIndex: Int?
        let position: Int
        
        init(_ data: [Int], readInput: ()->Int, position: Int) throws {
            var string = String(data[position])
            let e = string.count > 0 ? String(string.removeLast()) : ""
            let d = string.count > 0 ? String(string.removeLast()) : ""
            let c = string.count > 0 ? String(string.removeLast()) : ""
            let b = string.count > 0 ? String(string.removeLast()) : ""
            
            guard
                let mode2 = Mode(rawValue: Int(b) ?? 0),
                let mode1 = Mode(rawValue: Int(c) ?? 0),
                let code = OpCode(rawValue: Int(d+e) ?? -999)
            else {
                throw Errors.invalidOpCode
            }
            
            opCode = code
            let param2Mode = mode2
            let param1Mode = mode1
            
            switch opCode {
                case .add:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    writeIndex = data[position+3]
                    value = value1 + value2
                    output = nil

                case .multiply:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    writeIndex = data[position+3]
                    value = value1 * value2
                    output = nil

                case .input:
                    guard position+2 < data.count else { throw Errors.intCodeInvalidIndex }
                    writeIndex = data[position+1]
                    value = readInput()
                    output = nil

                case .output:
                    guard position+2 < data.count else { throw Errors.intCodeInvalidIndex }
                    output = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    value = nil
                    writeIndex = nil
                    
                case .jumpIfTrue:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    if value1 != 0 {
                        writeIndex = value2
                    } else {
                        writeIndex = position + 3
                    }
                    value = nil
                    output = nil
                    
                case .jumpIfFalse:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    if value1 == 0 {
                        writeIndex = value2
                    } else {
                        writeIndex = position + 3
                    }
                    value = nil
                    output = nil
                    
                case .lessThan:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    writeIndex = data[position+3]
                    value = value1 < value2 ? 1 : 0
                    output = nil

                case .equals:
                    guard position+3 < data.count else { throw Errors.intCodeInvalidIndex }
                    let value1 = param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                    let value2 = param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                    writeIndex = data[position+3]
                    value = value1 == value2 ? 1 : 0
                    output = nil

                case .finished:
                    writeIndex = nil
                    value = nil
                    output = nil
            }
            
            self.position = Program.incrementPosition(position, opCode: opCode, writeIndex: writeIndex)
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
    
    mutating func process(_ readInput: ()->Int) throws -> Int {
        guard !data.isEmpty else { throw Errors.intCodeNoData }
        var position = 0
        var output = -1
        let dataCount = data.count
        var program = try Program(data, readInput: readInput, position: position)
        while program.opCode != .finished {
            if let writeIndex = program.writeIndex, let value = program.value {
                data[writeIndex] = value
            } else if let programOutput = program.output {
                output = programOutput
            }
            
            position = program.position

            guard position < dataCount else { throw Errors.intCodeInvalidIndex }
            program = try Program(data, readInput: readInput, position: position)
        }
        return output
    }
}
