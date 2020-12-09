import Foundation

public struct Day9 {
    public func part1(_ input: [Int], step: Int = 25) -> Int {
        for i in step..<input.count {
            let previousStep = Set(input[i-step..<i])
            let value = input[i]
            if !validate(previousStep, value: value) {
                return value
            }
        }
        return -1
    }
    
    public func validate(_ input: Set<Int>, value: Int) -> Bool {
        var values = input
        while !values.isEmpty {
            let v = values.removeFirst()
            if values.contains(value - v) {
                return true
            }
        }
        return false
    }
    
    public func part2(_ input: [Int], sumsTo: Int = 257342611) -> Int {
        var pt1 = 0
        while pt1 < input.count {
            var pt2 = pt1 + 1
            var sum = input[pt1]
            while pt2 < input.count {
                sum += input[pt2]
                if sum == sumsTo {
                    let rangedValues = input[pt1...pt2]
                    let min = rangedValues.min()!
                    let max = rangedValues.max()!
                    return min + max
                } else if sum > sumsTo {
                    pt2 = input.count
                }
                pt2 += 1
            }
            pt1 += 1
        }
        
        return 0
    }
}
