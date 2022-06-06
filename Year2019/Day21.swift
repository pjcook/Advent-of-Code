//
//  Day21.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

public class SpringDroid {
    private var computer: SteppedIntComputer?
    private var springScript = [Int]()
    private var output = [String]()
    public var finalOutput = 0
    
    public init(_ input: [Int]) {
        computer = SteppedIntComputer(
            id: 6,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: completionHandler,
            forceWriteMode: false
        )
    }
    
    public func process(_ input: String) {
        springScript = input.compactMap {
            if let ascii = $0.asciiValue {
                return Int(ascii)
            }
            return nil
        }
        computer?.process()
    }
    
    private func readInput() -> Int {
        guard !springScript.isEmpty else {
            return -1
        }
        let value = springScript.removeFirst()
        return value
    }
    
    public var tempOutput = ""
    private func processOutput(_ value: Int) {
        guard let asciiValue = value.toAscii() else {
            print("OUTPUT:", value)
            finalOutput = value
            return
        }
        guard asciiValue != "\n" else {
            output.append(tempOutput)
            print(tempOutput)
            tempOutput = ""
            return
        }
        tempOutput += asciiValue
    }
    
    private func completionHandler() {
        print("FINISHED\n")
    }
}
