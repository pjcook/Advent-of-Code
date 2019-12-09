//
//  Day9.swift
//  Year2019
//
//  Created by PJ COOK on 08/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

func processSensorBoost(_ program: [Int], input: Int) -> (Int,[Int]) {
    let bigProgram = program + Array(repeating: 0, count: 1000)
    let computer = AdvancedIntCodeComputer(data: bigProgram)
    var output = [Int]()
    let result = computer.process({ input }, processOutput: { output.append($0) }, forceWriteMode: false)
    return (result, output)
}
