import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    public func part1(_ input: [Int]) -> Int {
        var count = 0
        for i in (1..<input.count) {
            if input[i-1] < input[i] {
                count += 1
            }
        }
        return count
    }
    
    public func part2(_ input: [Int]) -> Int {
        var count = 0
        var prev = input[0] + input[1] + input[2]
        for i in (3..<input.count) {
            let sum = input[i-2] + input[i-1] + input[i]
            if prev < sum {
                count += 1
            }
            prev = sum
        }
        return count
    }
}
