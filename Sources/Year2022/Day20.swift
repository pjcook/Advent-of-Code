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
    
    fileprivate func mix(_ typedInput: [Day20.Value], _ mixer: inout [Day20.Value], _ modder: Int) {
        for item in typedInput {
            guard item.value != 0 else { continue }
            let index = mixer.firstIndex(of: item)!
            var move = index + item.value
            if move < 0 {
                move = move % modder
                move = move + modder
            }
            if move > modder {
                move = move % modder
            }
            
            mixer.remove(at: index)
            mixer.insert(item, at: move)
        }
    }
    
    fileprivate func mixing(_ typedInput: [Value], timesToMix: Int) -> Int {
        let modder = typedInput.count - 1
        var mixer = typedInput

        for _ in (0..<timesToMix) {
            mix(typedInput, &mixer, modder)
        }
        
        let zero = mixer.firstIndex(where: { $0.value == 0 })!
        var one = zero + 1000
        if one >= typedInput.count {
            one = one % typedInput.count
        }
        var two = zero + 2000
        if two >= typedInput.count {
            two = two % typedInput.count
        }
        var three = zero + 3000
        if three >= typedInput.count {
            three = three % typedInput.count
        }
        
        return mixer[one].value + mixer[two].value + mixer[three].value
    }
    
    public func part1(_ input: [Int]) -> Int {
        let typedInput = input.map(Value.init)
        return mixing(typedInput, timesToMix: 1)
    }
    
    public func part2(_ input: [Int]) -> Int {
        let typedInput = input.map {
            Value($0 * 811589153)
        }
        return mixing(typedInput, timesToMix: 10)
    }
}

extension Day20 {
    public func index(for index: Int, value: Int, top: Int) -> Int {
        guard value != 0 else { return index }
        var newIndex = index + value
        if value > 0 {
            while newIndex > top {
                newIndex = newIndex - top
            }
        } else {
            while newIndex < 0 {
                newIndex = newIndex + top
            }
        }
        return newIndex
    }
}
