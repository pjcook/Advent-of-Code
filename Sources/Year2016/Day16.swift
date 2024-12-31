//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}
    
    public func part1(_ input: String, length: Int) -> String {
        let values = makeCorrectLength(input, length: length)
        return calculateChecksum(Array(values.prefix(length))).map(String.init).joined()
    }
    
    public func part2(_ input: String, length: Int) -> String {
        return ""
    }
}

extension Day16 {
    func makeCorrectLength(_ input: String, length: Int) -> [Int] {
        var values: [Int] = input.map { Int(String($0))! }
        
        // make correct length
        while values.count < length {
            let list = values.reversed()
            values.append(0)
            for i in list {
                values.append(i == 1 ? 0 : 1)
            }
        }
        
        return values
    }
    
    func calculateChecksum(_ values: [Int]) -> [Int] {
        var checksum: [Int] = []
        
        for i in stride(from: 1, through: values.count - 1, by: 2) {
            checksum.append(values[i] == values[i - 1] ? 1 : 0)
        }
        
        if checksum.count % 2 == 0 {
            return calculateChecksum(checksum)
        }
        
        return checksum
    }
}
