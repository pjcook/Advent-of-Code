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
    var input = [Int]()
    var output = [Int]()
    
    init(_ input: String) {
        self.input = input.map { Int(String($0))! }
    }
    
    func resolve(phases: Int) -> [Int] {
        let length = input.count
        let halfLength = length / 2
                
        for phase in 0..<phases {
            output.removeAll()

            for iteration in 0..<length {
                if iteration % 1000 == 0 {
                    print(phase, iteration)
                }
                
                var result = 0
                var lastMultiplier = multiplier(iteration, iteration)
                for i in iteration..<length {
                    if iteration < halfLength {
                        lastMultiplier = multiplier(iteration, i)
                    }
                    result += input[i] * lastMultiplier
                }
                output.append(abs(result - Int(result / 10 * 10)))
            }
            
            input = output
            print(phase)
        }
        
        return output
    }
    
    func result(_ startIndex: Int) -> Int {
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
    
    func multiplier(_ y: Int, _ x: Int) -> Int {
        let numberOfPatterns = basePattern.count
        let remainder = (x+1) / (y+1)
        return basePattern[remainder%numberOfPatterns]
    }
}

