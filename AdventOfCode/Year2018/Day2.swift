//
//  Day2.swift
//  Year2018
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

func calculateChecksum(_ data: [String]) -> Int {
    func disassembleString(_ input: String) -> [Character:Int] {
        var input = input
        var output = [Character:Int]()
        while !input.isEmpty {
            let value = input.removeLast()
            output[value] = (output[value, default: 0]) + 1
        }
        return output
    }
    
    func count(_ count: Int, _ input: [Character:Int]) -> Int {
        return input.first { $0.value == count } != nil ? 1 : 0
    }
    
    let dissassembled = data.map { disassembleString($0) }
    let count2 = dissassembled.reduce(0) { $0 + count(2, $1) }
    let count3 = dissassembled.reduce(0) { $0 + count(3, $1) }
    return count2 * count3
}

func hasOnlyOneNonMatchingCharacter(_ value1: String, _ value2: String) -> Int {
    var count = 0
    for (a,b) in zip(value1, value2) {
        if a != b { count += 1 }
        if count > 1 { break }
    }
    return count
}

func extractNonMatchingCharacters(_ value1: String, _ value2: String) -> String {
    var output = ""
    for (a,b) in zip(value1, value2) {
        if a == b { output += String(a) }
    }
    return output
}

func matchBoxIDs(_ data: [String]) -> String {
    var data = data
    var string = ""
    var value1 = ""
    var value2 = ""
    
    while !data.isEmpty {
        string = data.removeFirst()
        
        for next in data {
            if 1 == hasOnlyOneNonMatchingCharacter(string, next) {
                value1 = string
                value2 = next
                break
            }
        }
    }
        
    return extractNonMatchingCharacters(value1, value2)
}
