//
//  Day9.swift
//  Year2019
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

func processSensorBoost(_ program: [Int], input: Int) throws -> (Int,[Int]) {
    let bigProgram = program + Array(repeating: 0, count: program.count)
    let computer = AdvancedIntCodeComputer(data: bigProgram)
    var output = [Int]()
    let result = try computer.process({ input }, processOutput: { output.append($0) }, forceWriteMode: false)
    return (result, output)
}
