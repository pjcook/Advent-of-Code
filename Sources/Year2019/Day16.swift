//
//  Day16.swift
//  Year2019
//
//  Created by PJ COOK on 16/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

public class FFT {
    public let basePattern = [0, 1, 0, -1]
    public var input = [Int]()
    public var output = [Int]()
    
    public init(_ input: [Int]) {
        self.input = input
    }
    
    fileprivate func sumIteration(_ iteration: Int, _ length: Int) -> Int {
        var result = 0
        var lastMultiplier = multiplier(iteration, iteration)
        var i = iteration
        while i < length {
            lastMultiplier = multiplier(iteration, i)
            switch lastMultiplier {
            case 0:
                i += iteration+1
            case 1:
                let bounds = min(length-i, iteration+1)
                result += sumSlice(i, i+bounds)
                i += iteration+1
            case -1:
                let bounds = min(length-i, iteration+1)
                result += sumNegativeSlice(i, i+bounds)
                i += iteration+1
            default:
                break
            }
        }
        return result
    }
    
    public func sumNegativeSlice(_ start: Int, _ end: Int) -> Int {
        return input[start..<end].reduce(0) { $0 + ($1 * -1) }
    }
    
    public func sumSlice(_ start: Int, _ end: Int) -> Int {
        return input[start..<end].reduce(0, +)
    }
    
    public func resolve2(phases: Int) -> [Int] {
        output = (1...phases)
            .reduce(input) { values, _ -> [Int] in
                var total = values.reduce(0, +)
                return values.map { value in
                    defer { total -= value }
                    return total % 10
                }
            }
        return output
    }
    
    public func resolve(phases: Int) -> [Int] {
        let length = input.count
        let halfLength = length / 2
                
        for _ in 0..<phases {
            output.removeAll()

            for iteration in 0..<length {
//                if iteration % 10000 == 0 {
//                    print(phase, iteration, halfLength, length, Date())
//                }
                
                var result = 0
                if iteration < halfLength {
                    result = sumIteration(iteration, length)
                } else {
                    result = sumSlice(iteration, length)
                }
                output.append(abs(result - Int(result / 10 * 10)))
            }
            
            input = output
//            print(phase, Date())
        }
        
        return output
    }
    
    public func result(_ startIndex: Int) -> Int {
        var answer = 0
        answer += output[startIndex + 0] * 10000000
        answer += output[startIndex + 1] * 1000000
        answer += output[startIndex + 2] * 100000
        answer += output[startIndex + 3] * 10000
        answer += output[startIndex + 4] * 1000
        answer += output[startIndex + 5] * 100
        answer += output[startIndex + 6] * 10
        answer += output[startIndex + 7]
        return answer
    }
    
    public func multiplier(_ y: Int, _ x: Int) -> Int {
        let numberOfPatterns = basePattern.count
        let remainder = (x+1) / (y+1)
        return basePattern[remainder%numberOfPatterns]
    }
}

