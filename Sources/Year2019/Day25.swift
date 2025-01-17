//
//  Day25.swift
//  Year2019
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public final class Day25 {
    public init() {}
    private let computer = Computer(forceWriteMode: false)
    private var finished = false
    private var isPart2 = false
    private var inputs = [Int]()
    private var outputs = [Int]()
    private var row = ""
    private var finalOutput = 0
    private var history = [String]()
    
    public func part1(_ input: [Int]) -> Int {
        finished = false
        isPart2 = false
        computer.reset()
        computer.delegate = self
        computer.loadProgram(input)
        inputs = [Int]()
        outputs = [Int]()
        row = ""
        finalOutput = 0
        history = []
        
        populateValidActions()
        
        while !finished {
            computer.tick()
        }
        
        return finalOutput
    }
    
    public func perform(_ action: Action) {
        inputs.append(contentsOf: action.command.toAscii())
    }
    
    public func populateValidActions() {
        perform(.move(.north))
        perform(.take("sand"))
        perform(.move(.north))
        perform(.move(.north))
        perform(.take("astrolabe"))
        perform(.move(.south))
        perform(.move(.south))
        perform(.move(.south))
        perform(.move(.west))
        perform(.move(.north))
        perform(.take("shell"))
        perform(.move(.south))
        perform(.move(.south))
        perform(.move(.west))
        perform(.take("ornament"))
        perform(.move(.west))
        perform(.move(.south))
        perform(.move(.south))
    }
}

public enum Action {
    public enum Movement: String {
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

extension Day25: ComputerDelegate {
    public func readInput(id: Int) -> Int {
        guard !inputs.isEmpty else {
            return -1
        }
        return inputs.removeFirst()
    }
    
    public func computerFinished(id: Int) {
        finished = true
        finalOutput = Int(history.last!
            .replacingOccurrences(of: "\"Oh, hello! You should be able to get in by typing ", with: "")
            .replacingOccurrences(of: " on the keypad at the main airlock.\"", with: ""))!
    }
    
    public func processOutput(id: Int, value: Int) {
        guard let asciiValue = value.toAscii() else {
            outputs.append(value)
            return
        }
        if asciiValue == "\n" {
            print(row)
            history.append(row)
            row = ""
        } else {
            row += asciiValue
        }
    }
}
