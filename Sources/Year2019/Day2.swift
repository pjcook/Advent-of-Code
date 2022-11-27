//
//  Day2.swift
//  Year2019
//
//  Created by PJ COOK on 03/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

public struct IntCodeComputer {
    public enum OpCode: Int {
        case add = 1
        case multiply = 2
        case finished = 99
    }

    private var data: [Int]
    public var readData: [Int] { return data }
    
    public init(data: [Int]) {
        self.data = data
    }
    
    public mutating func process() throws {
        guard !data.isEmpty else { throw Errors.intCodeNoData }
        var position = 0
        let dataCount = data.count
        guard var opCode = OpCode(rawValue: data[position]) else { throw Errors.invalidOpCode }
        while opCode != .finished {
            guard position+3 < dataCount else { throw Errors.intCodeInvalidIndex }
            let value1 = data[data[position+1]]
            let value2 = data[data[position+2]]
            let endIndex = data[position+3]
            
            switch opCode {
            case .add: data[endIndex] = value1 + value2
            case .multiply: data[endIndex] = value1 * value2
            case .finished: break
            }

            position = position + 4
            guard position < dataCount else { throw Errors.intCodeInvalidIndex }
            guard let newOpCode = OpCode(rawValue: data[position]) else { throw Errors.invalidOpCode }
            opCode = newOpCode
        }
    }
    
    public static func computeProgram(data: [Int]) throws -> Int {
        var computer = IntCodeComputer(data: data)
        try computer.process()
        return computer.readData[0]
    }
}

public func calculateNounVerb(expectedResult: Int, data: [Int]) throws -> (Int, Int) {
    var data = data
    
    for noun in 3..<99 {
        for verb in 3..<(99/2)+1 {
            data[1] = noun
            data[2] = verb
            var computer = IntCodeComputer(data: data)
            try computer.process()
            if computer.readData[0] == expectedResult {
                return (noun, verb)
            }
        }
    }
    throw Errors.calculateNounVerbNoResult
    
}
