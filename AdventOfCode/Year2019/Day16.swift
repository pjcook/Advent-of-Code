//
//  Day16.swift
//  Year2019
//
//  Created by PJ COOK on 16/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

class FFT {
    let basePattern = [0, 1, 0, -1]
    var input = ""
    var output = ""
    
    init(_ input: String) {
        self.input = input
    }
    
    func resolve(phases: Int) -> String {
        let length = input.count
        
//        buildPatterns(length)
        
        for phase in 0..<phases {
            output = ""

            for iteration in 0..<length {
                let pattern = buildPattern(iteration, itemCount: length)
//                let pattern = cachedPatterns[iteration]
                var result = 0
                for (index, char) in input.enumerated() {
                    result += Int(String(char))! * pattern[index]
                }
                output += String(String(result).last!)
            }
            
            input = output
            print(phase)
        }
        
        return output
    }
    
    var cachedPatterns: [[Int]] = []
    private func buildPatterns(_ length: Int) {
        for iteration in 0..<length {
            let pattern = buildPattern(iteration, itemCount: length)
            cachedPatterns.append(pattern)
        }
    }
    
    private func buildPattern(_ iteration: Int, itemCount: Int) -> [Int] {
        var pattern = [Int]()
        var pointer = 0
        while pattern.count < itemCount+1 {
            let value = basePattern[pointer]
            pattern.append(contentsOf: Array(repeating: value, count: iteration+1))
            pointer = nextPointer(pointer)
        }
        pattern.removeFirst()
        return pattern
    }
    
    private func nextPointer(_ pointer: Int) -> Int {
        return pointer == basePattern.count-1 ? 0 : pointer+1
    }
}

class FFT2 {
    let basePattern = [0, 1, 0, -1]
    var input = [Int]()
    var output = [Int]()
    
    init(_ input: [Int]) {
        self.input = input
    }
    
    func resolve(phases: Int) -> [Int] {
        let length = input.count
        
        buildPatterns(length)
        
        for phase in 0..<phases {
            
            output.removeAll()
            
            for iteration in 0..<length {
                var result = 0
                let pattern = cachedPatterns[iteration]
                for (a,b) in zip(input, pattern) {
                    result += a * b
                }
                output.append(Int(String(result))!)
            }
            
            input = output
            print(phase)
        }
        
        return output
    }
    
    var cachedPatterns: [[Int]] = []
    private func buildPatterns(_ length: Int) {
        for iteration in 0..<length {
            let pattern = buildPattern(iteration, itemCount: length)
            cachedPatterns.append(pattern)
        }
    }
    
    private func buildPattern(_ iteration: Int, itemCount: Int) -> [Int] {
        var pattern = [Int]()
        var pointer = 0
        while pattern.count < itemCount+1 {
            let value = basePattern[pointer]
            pattern.append(contentsOf: Array(repeating: value, count: iteration+1))
            pointer = nextPointer(pointer)
        }
        pattern.removeFirst()
        return pattern
    }
    
    private func nextPointer(_ pointer: Int) -> Int {
        return pointer == basePattern.count-1 ? 0 : pointer+1
    }
}
