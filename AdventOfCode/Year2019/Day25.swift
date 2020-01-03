//
//  Day25.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation

class InvestigationDroid {
    private var computer: SteppedIntComputer?
    private var inputs = [Int]()
    private var outputs = [Int]()

    init(_ input: [Int]) {
        computer = SteppedIntComputer(
            id: 6,
            data: input,
            readInput: readInput,
            processOutput: processOutput,
            completionHandler: completionHandler,
            forceWriteMode: false
        )
    }
    
    func process() {
        computer?.process()
    }
    
    private func nextAction(_ action: Action) {
        inputs = action.command.toAscii()
    }
    
    private func readInput() -> Int {
    //        print(computer!.id, "readInput:", inputs)
            guard !inputs.isEmpty else {
                return -1
            }
            return inputs.removeFirst()
        }
        
    private var tempOutput = ""
    private func processOutput(_ value: Int) {
    //        print(computer!.id, "output:", value)
//        outputs.append(value)
        guard let asciiValue = value.toAscii() else {
            outputs.append(value)
            return
        }
        if asciiValue == "\n" {
            print(tempOutput)
            tempOutput = ""
        } else {
            tempOutput += asciiValue
        }
    }
        
    private func completionHandler() {
    //        print("[\(computer!.id)] FINISHED\n")
    }
}

extension InvestigationDroid {
    enum Action {
        enum Movement: String {
            case north, south, east, west
        }
        
        case move(Movement)
        case take(String)
        case drop(String)
        case inventory
        
        var command: String {
            var command = ""
            switch self {
            case let .move(movement):
                command = movement.rawValue
            case let .take(name):
                command = "take \(name)"
            case let .drop(name):
                command = "drop \(name)"
            case .inventory:
                command = "inv"
            }
            return command + "\n"
        }
    }
}
