//
//  Day5.swift
//  Year2019
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

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
        }
        
        enum Mode: Int {
            case position = 0
            case immediate = 1
        }
        
        let opCode: OpCode
        let param1Mode: Mode
        let param2Mode: Mode
        
        init(_ value: String) throws {
            var value = value
            let e = value.count > 0 ? String(value.removeLast()) : ""
            let d = value.count > 0 ? String(value.removeLast()) : ""
            let c = value.count > 0 ? String(value.removeLast()) : ""
            let b = value.count > 0 ? String(value.removeLast()) : ""
            
            guard
                let mode2 = Mode(rawValue: Int(b) ?? 0),
                let mode1 = Mode(rawValue: Int(c) ?? 0),
                let code = OpCode(rawValue: Int(d+e) ?? -999)
            else { throw Errors.invalidOpCode }
            
            opCode = code
            param2Mode = mode2
            param1Mode = mode1
        }
    }

    private var data: [Int]
    var readData: [Int] { return data }
    
    init(data: [Int]) {
        self.data = data
    }
    
    mutating func process(_ input: Int) throws -> Int {
        guard !data.isEmpty else { throw Errors.intCodeNoData }
        var position = 0
        var output = -1
        let dataCount = data.count
        var program = try Program(String(data[position]))
        while program.opCode != .finished {
            
            switch program.opCode {
            case .add:
                guard position+3 < dataCount else { throw Errors.intCodeInvalidIndex }
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                let endIndex = data[position+3]
                data[endIndex] = value1 + value2
                position += 4

            case .multiply:
                guard position+3 < dataCount else { throw Errors.intCodeInvalidIndex }
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                let endIndex = data[position+3]
                data[endIndex] = value1 * value2
                position += 4

            case .input:
                data[data[position+1]] = input
                position += 2

            case .output:
                output = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                position += 2
                
            case .jumpIfTrue:
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                if value1 != 0 {
                    position = value2
                } else {
                    position += 3
                }
                
            case .jumpIfFalse:
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                if value1 == 0 {
                    position = value2
                } else {
                    position += 3
                }
                
            case .lessThan:
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                let endIndex = data[position+3]
                data[endIndex] = value1 < value2 ? 1 : 0
                position += 4

            case .equals:
                let value1 = program.param1Mode == .immediate ? data[position+1] : data[data[position+1]]
                let value2 = program.param2Mode == .immediate ? data[position+2] : data[data[position+2]]
                let endIndex = data[position+3]
                data[endIndex] = value1 == value2 ? 1 : 0
                position += 4

            case .finished: break
            }

            guard position < dataCount else { throw Errors.intCodeInvalidIndex }
            program = try Program(String(data[position]))
        }
        return output
    }
}
