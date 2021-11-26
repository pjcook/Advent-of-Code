import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    public func part1(_ input: String) -> Int {
        var floor = 0
        for char in input {
            switch char {
            case "(": floor += 1
            case ")": floor -= 1
            default: break
            }
        }
        return floor
    }
    
    public func part1b(_ input: String) -> Int {
        input.reduce(0) { partialResult, char in
            switch char {
            case "(": return partialResult + 1
            case ")": return partialResult - 1
            default: return partialResult
            }
        }
    }
    
    public func part2(_ input: String) -> Int {
        var floor = 0
        var index = 0
        
        for char in input {
            switch char {
            case "(": floor += 1
            case ")": floor -= 1
            default: break
            }
            index += 1
            if floor == -1 {
                break
            }
        }
        
        return index
    }
    
    public func part2b(_ input: String) -> Int {
        var floor = 0
        var index = 0
        
        while index < input.count && floor != -1 {
            let char = input[index]
            switch char {
            case "(": floor += 1
            case ")": floor -= 1
            default: break
            }
            index += 1
        }
        
        return index
    }
}
