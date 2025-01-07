import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: Int, start: Int = 1) -> Int {
        var i = 0
        let a = 856800
        var lowest = Int.max
        for count in (0...a).reversed() {
            i += 1
            var newResult = 0
            let range: [Int] = Array(1...max(1,count/2)) + [count]
            for i in range {
                if count % i == 0 {
                    newResult += i * 10
                }
            }
            if newResult >= input {
                print(count, newResult, newResult >= input)
                lowest = min(lowest, count)
            }
            if lowest - count > 50000 {
                break
            }
        }
        return lowest
    }
    
    public func part2(_ input: Int) -> Int {
        var i = 0
        let a = 850000
        var lowest = Int.max
        for count in a...Int.max {
            i += 1
            var newResult = 0
            let rangeMax = count/2
            let rangeMin = max(1, min(count / 50, rangeMax))
            let range: [Int] = Array(rangeMin...rangeMax) + [count]
            for i in range {
                if (count - (i * 50)) <= i, count % i == 0 {
                    newResult += i * 11
                }
            }
            if newResult >= input {
                print(count, newResult, newResult >= input)
                lowest = min(lowest, count)
            }
            if lowest != Int.max {
                break
            }
        }
        return lowest
    }
}
