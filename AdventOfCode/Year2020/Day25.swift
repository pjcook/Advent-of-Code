import Foundation
import StandardLibraries

public struct Day25 {
    public init() {}
    
    public func part1(cardKey: Int, doorKey: Int) -> Int {
        var value = 1
        var loops = 0
        while value != cardKey {
            loops += 1
            value = (value * 7) % 20201227
        }
        
        value = 1
        for _ in 0..<loops {
            value = (doorKey * value) % 20201227
        }
        return value
    }
    
    public func part1_chris(cardKey: Int, doorKey: Int) -> Int {
        let subject = 7
        var value = 1
        var loops = 0
        var notSolved = true
        
        while notSolved {
            if value != cardKey {
                loops += 1
                value = subject * value
                value = value % 20201227
            } else {
                notSolved = false
            }
        }
        
        value = 1
        for _ in 0..<loops {
            value = (doorKey * value) % 20201227
        }
        
        return value
    }
}
