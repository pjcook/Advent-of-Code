import Foundation

public struct Day9 {
    public init() {}
    
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
                    let rangedValues = input[pt1...pt2].sorted()
                    return rangedValues.first! + rangedValues.last!
                } else if sum > sumsTo {
                    pt2 = input.count
                }
                pt2 += 1
            }
            pt1 += 1
        }
        
        return 0
    }
    
    public func part2_chris(input: [Int], invalidNumber: Int = 257342611) -> Int {
        for index in 0..<input.count {
            var sum: Int = 0
            var allValues: [Int] = []
            for value in input[index ..< input.count] {
                sum += value
                allValues.append(value)
                if sum == invalidNumber {
                    let s = allValues.sorted()
                    return s.first! + s.last!
                } else if sum >= invalidNumber {
                    break
                }
            }
        }
        
        return -1
    }
}
