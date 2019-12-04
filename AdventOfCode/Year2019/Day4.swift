//
//  Day4.swift
//  Year2019
//
//  Created by PJ COOK on 04/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct VenusPasswordCalculator {
    func howManyValidPasswordsInRange(min: Int, max: Int) -> Int {
        var count = 0
        
        for i in min...max {
            if isValidPassword(input: i) { count += 1 }
        }
        
        return count
    }
    
    func isValidPassword(input: Int) -> Bool {
        let password = String(input)
        let characters = password.compactMap { Int(String($0)) }
        guard characters == characters.sorted() else { return false }
        var hasDouble = false
        let count = characters.count
        var ignoreCharacter: Int? = nil
        for i in 0..<count-1 {
            if ignoreCharacter != characters[i], characters[i] == characters[i+1] {
                if i+2 <= count-1, characters[i] == characters[i+2] {
                    ignoreCharacter = characters[i]
                } else {
                    hasDouble = true
                    break
                }
            }
        }
        
        return hasDouble
    }
}
