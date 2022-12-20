//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day20 {
    public init() {}
    
    struct Value: Hashable {
        let id = UUID().uuidString
        let value: Int
        init(_ value: Int) {
            self.value = value
        }
    }
    
    fileprivate func mix(_ typedInput: [Day20.Value], _ mixer: inout [Day20.Value], _ topIndex: Int) {
        for item in typedInput {
            guard item.value != 0 else { continue }
            let originalIndex = mixer.firstIndex(of: item)!
            let moveToIndex = (((originalIndex + item.value) % topIndex) + topIndex) % topIndex
            
            mixer.remove(at: originalIndex)
            mixer.insert(item, at: moveToIndex)
        }
    }
    
    fileprivate func mixing(_ typedInput: [Value], timesToMix: Int) -> Int {
        let topIndex = typedInput.count - 1
        var mixer = typedInput

        // Mixing
        for _ in (0..<timesToMix) {
            mix(typedInput, &mixer, topIndex)
        }
        
        // Calculate result
        let zero = mixer.firstIndex(where: { $0.value == 0 })!
        let one = (zero + 1000) % typedInput.count
        let two = (zero + 2000) % typedInput.count
        let three = (zero + 3000) % typedInput.count
        
        return mixer[one].value + mixer[two].value + mixer[three].value
    }
    
    public func part1(_ input: [Int]) -> Int {
        let typedInput = input.map(Value.init)
        return mixing(typedInput, timesToMix: 1)
    }
    
    public func part2(_ input: [Int]) -> Int {
        let typedInput = input.map { Value($0 * 811589153) }
        return mixing(typedInput, timesToMix: 10)
    }
}
