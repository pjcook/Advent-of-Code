import Foundation
import StandardLibraries

public struct Day5 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        var freshIngredients = 0
        let (ranges, ingredients) = parse(input)

        for ingredient in ingredients {
            for range in ranges {
                if range.contains(ingredient) {
                    freshIngredients += 1
                    break
                }
            }
        }

        return freshIngredients
    }

    public func part2(_ input: [String]) -> Int {
        let (ranges, _) = parse(input)
        return ranges.reduce(0) { $0 + $1.upperBound - $1.lowerBound + 1 }
    }
}

extension Day5 {
    func parse(_ input: [String]) -> ([ClosedRange<Int>], [Int]) {
        var ranges: [ClosedRange<Int>] = []
        var ids: [Int] = []
        var parseRanges = true

        mainLoop: for line in input {
            if line.isEmpty {
                parseRanges = false
                continue
            }

            if parseRanges {
                let parts = line.split(separator: "-").map(String.init).map(Int.init)
                var range = parts[0]!...parts[1]!
                var overlaps: [ClosedRange<Int>] = []
                var indexesToRemove: [Int] = []

                for i in 0..<ranges.count {
                    let a = ranges[i]
                    if a.overlaps(range) {
                        indexesToRemove.append(i)
                        overlaps.append(a)
                    }
                }

                for i in indexesToRemove.reversed() {
                    ranges.remove(at: i)
                }

                range = overlaps.reduce(range) { min($0.lowerBound, $1.lowerBound)...max($0.upperBound, $1.upperBound) }
                ranges.append(range)
            } else {
                ids.append(Int(line)!)
            }
        }

        return (ranges, ids)
    }
}
