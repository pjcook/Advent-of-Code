//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day15 {
    public init() {}
    
    private let af: Int = 16807
    private let bf: Int = 48271
    private let dx: Int = 2147483647
    
    public func part1(a: Int, b: Int) -> Int {
        var a = a
        var b = b
        var count = 0
        
        for _ in 0..<40_000_000 {
            a = a * af % dx
            b = b * bf % dx
            
            if a.binary.suffix(16) == b.binary.suffix(16) {
                count += 1
            }
        }
        
        return count
    }
    
    public func part2(a: Int, b: Int) -> Int {
        var a = a
        var b = b
        var count = 0
        var queueA = [Int]()
        var queueB = [Int]()
        var pairsPointer = 0
        
        while queueA.count < 5_000_000 || queueB.count < 5_000_000 {
            var change = false
            if queueA.count < 5_000_000 {
                a = a * af % dx
                if a % 4 == 0 {
                    queueA.append(a)
                    change = true
                }
            }
            if queueB.count < 5_000_000 {
                b = b * bf % dx
                if b % 8 == 0 {
                    queueB.append(b)
                    change = true
                }
            }
            
            if change, queueA.count > pairsPointer && queueB.count > pairsPointer {
                let a = queueA[pairsPointer]
                let b = queueB[pairsPointer]
                if a.binary.suffix(16) == b.binary.suffix(16) {
                    count += 1
                }
                pairsPointer += 1
            }
        }
        
        return count
    }
}
