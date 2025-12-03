import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        parse(input)
            .map { findLargestJoltage(input: $0, count: 2) }
            .reduce(0, +)
    }

    public func part2(_ input: [String]) -> Int {
        parse(input)
            .map { findLargestJoltage(input: $0, count: 12) }
            .reduce(0, +)
    }

    struct Info {
        let value: Int
        let index: Int
    }
}

extension Day3 {
    func findLargestJoltage(input: [Int], count: Int) -> Int {
        var values = [Info]()
        var indexesToIgnore = [Int]()
        var lowestIndex = 0

        // Find the index of the first largest value at a valid index
        let range = lowestIndex..<input.count - count + 1
        let initialInfo = findLargestInRange(input: input, range: range, ignoringIndexes: [])
        values.append(initialInfo)
        indexesToIgnore.append(initialInfo.index)
        lowestIndex = initialInfo.index

        // Calculate the remaining values
        while values.count < count {
            let range = lowestIndex..<input.count - count + 1 + values.count
            let info = findLargestInRange(input: input, range: range, ignoringIndexes: indexesToIgnore)
            let stillNeed = count - 1 - values.count + indexesToIgnore.filter { $0 > lowestIndex }.count
            let lastIndex = input.count - stillNeed

            if info.index <= lastIndex {
                lowestIndex = info.index
            }

            values.append(info)
            indexesToIgnore.append(info.index)
        }

        // Convert results to value
        return Int(values
            .sorted(by: { $0.index < $1.index })
            .map { $0.value }
            .map(String.init)
            .joined()
        )!
    }

    func findLargestInRange(input: [Int], range: Range<Int>, ignoringIndexes: [Int]) -> Info {
        var largest = 0
        var largestIndex = range.lowerBound

        for i in range where !ignoringIndexes.contains(i) {
            if input[i] > largest {
                largest = input[i]
                largestIndex = i
                if largest == 9 {
                    break   // exit early, can't get any higher, excessive optimisation that makes 0.0001s difference to part 2
                }
            }
        }

        return Info(value: largest, index: largestIndex)
    }

    func parse(_ input: [String]) -> [[Int]] {
        input.map { line in
            line.compactMap { Int(String($0)) }
        }
    }
}
