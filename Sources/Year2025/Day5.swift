import Foundation
import StandardLibraries

public struct Day5 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let (ranges, ingredients) = parse(input)
        var freshIngredients = 0

        ingredients.forEach { ingredient in
            if ranges.first(where: { $0.contains(ingredient)}) != nil {
                freshIngredients += 1
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
        // Find file break
        let index = input.firstIndex(of: "")!

        // Parse Ranges
        var ranges: [ClosedRange<Int>] = []
        for i in 0..<index {
            let line = input[i]
            let parts = line.split(separator: "-").map(String.init).map(Int.init)
            ranges.compress(with: parts[0]!...parts[1]!)
        }

        // Parse Ingredients
        var ingredients: [Int] = []
        for i in index+1..<input.count {
            ingredients.append(Int(input[i])!)
        }

        return (ranges, ingredients)
    }
}
