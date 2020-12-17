import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func solve(_ input: [Int], maxTime: Int = 2020) -> Int {
        var time = input.count + 1
        var lastSpoken = 0
        var numbers = [Int:Int]()
        
        for i in 0..<input.count {
            numbers[input[i]] = i+1
        }

        while time < maxTime {
            if let spoken = numbers[lastSpoken] {
                numbers[lastSpoken] = time
                lastSpoken = time - spoken
            } else {
                numbers[lastSpoken] = time
                lastSpoken = 0
            }
            time += 1
        }
        
        return lastSpoken
    }
}
