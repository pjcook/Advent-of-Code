//
//  Day1.swift
//  Year2018
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

public func processFrequencyChanges(_ data: [Int]) -> Int {
    return data.reduce(0) { $0 + $1 }
}

public func findFirstDuplicateFrequency(_ data: [Int]) -> Int {
    var additives = [0:0]
    let itemCount = data.count
    var value = 0
    var index = 0
    while true {
        value += data[index]
        if additives[value] != nil { return value }
        additives[value] = value
        
        index += 1
        if index == itemCount { index = 0 }
    }
}
