import Foundation
import StandardLibraries

public struct Day10 {
    public func part1(_ input: [Int]) -> Int {
        var input = input, count1 = 0, count3 = 1, previous = 0
        while !input.isEmpty {
            let value = input.removeFirst()
            switch abs(previous - value) {
            case 1: count1 += 1
            case 3: count3 += 1
            default: break
            }
            previous = value
        }
        return count1 * count3
    }
    
    public func part2(_ input: [Int]) -> Int {
        let input = [0] + input
        var items = [Int: Int]()
        for i in 0..<input.count {
            let value = input[i]
            let lowerBound = max(i-3, 0)
            let possiblePaths = input[lowerBound..<i].filter { $0 >= value - 3 }
            let count = possiblePaths.reduce(0) { $0 + (items[$1] ?? 1) }
            if value > 0 {
                items[value] = count
            }
        }
        return items[input.last!]!
    }
}
