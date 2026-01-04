import Foundation

// https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
public class Day10peti {
    public init() {}

    // MARK: - Python Logic Conversion

    // Helper to generate all combinations of button presses
    func combinations<T>(_ elements: [T], k: Int) -> [[T]] {
        guard k > 0 else { return [[]] }
        guard elements.count >= k else { return [] }
        if k == 1 { return elements.map { [$0] } }
        var result: [[T]] = []
        for (i, el) in elements.enumerated() {
            let rest = Array(elements[(i+1)...])
            for comb in combinations(rest, k: k-1) {
                result.append([el] + comb)
            }
        }
        return result
    }

    // Generate patterns as in Python
    func patterns(coeffs: [[Int]]) -> [ [Int] : [ [Int] : Int ] ] {
        let numButtons = coeffs.count
        let numVariables = coeffs[0].count
        var out: [ [Int] : [ [Int] : Int ] ] = [:]
        // Generate all parity patterns
        let parityPatterns = product(Array(repeating: [0,1], count: numVariables))
        for parity in parityPatterns {
            out[parity] = [:]
        }
        for numPressed in 0...numButtons {
            for buttons in combinations(Array(0..<numButtons), k: numPressed) {
                var pattern = Array(repeating: 0, count: numVariables)
                for i in buttons {
                    for j in 0..<numVariables {
                        pattern[j] += coeffs[i][j]
                    }
                }
                let parityPattern = pattern.map { $0 % 2 }
                if out[parityPattern]?[pattern] == nil {
                    out[parityPattern]?[pattern] = numPressed
                }
            }
        }
        return out
    }

    // Cartesian product helper
    func product(_ arrays: [[Int]]) -> [[Int]] {
        var result: [[Int]] = [[]]
        for array in arrays {
            var newResult: [[Int]] = []
            for prefix in result {
                for value in array {
                    newResult.append(prefix + [value])
                }
            }
            result = newResult
        }
        return result
    }

    // Memoization for solve_single_aux
    var solveSingleAuxCache: [ [Int] : Int ] = [:]

    func solveSingle(coeffs: [[Int]], goal: [Int]) -> Int {
        let patternCosts = patterns(coeffs: coeffs)
        solveSingleAuxCache = [:]
        func solveSingleAux(_ goal: [Int]) -> Int {
            if goal.allSatisfy({ $0 == 0 }) { return 0 }
            if let cached = solveSingleAuxCache[goal] { return cached }
            var answer = 1000000
            let parity = goal.map { $0 % 2 }
            if let patternsForParity = patternCosts[parity] {
                for (pattern, patternCost) in patternsForParity {
                    if zip(pattern, goal).allSatisfy({ $0 <= $1 }) {
                        let newGoal = zip(pattern, goal).map { (i, j) in (j - i) / 2 }
                        let candidate = patternCost + 2 * solveSingleAux(newGoal)
                        answer = min(answer, candidate)
                    }
                }
            }
            solveSingleAuxCache[goal] = answer
            return answer
        }
        return solveSingleAux(goal)
    }

    // Parse a line as in Python
    func parseLine(_ line: String) -> (coeffs: [[Int]], goal: [Int])? {
        let parts = line.split(separator: " ").map { String($0) }
        guard parts.count >= 2 else { return nil }
        let goalStr = parts.last!
        let goal = goalStr.trimmingCharacters(in: CharacterSet(charactersIn: "()[]{}"))
            .split(separator: ",").compactMap { Int($0) }
        let coeffs = parts[1..<(parts.count-1)].map {
            $0.trimmingCharacters(in: CharacterSet(charactersIn: "()[]{}"))
                .split(separator: ",").compactMap { Int($0) }
        }
        // Convert to binary presence as in Python
        let coeffsBinary = coeffs.map { r in
            (0..<goal.count).map { i in r.contains(i) ? 1 : 0 }
        }
        return (coeffsBinary, goal)
    }

    // Main solve function
    public func solve(_ input: [String]) -> Int {
        var score = 0
        for (i, line) in input.enumerated() {
            guard let (coeffs, goal) = parseLine(line) else { continue }
            let subscore = solveSingle(coeffs: coeffs, goal: goal)
            print("Line \(i+1)/\(input.count): answer \(subscore)")
            score += subscore
        }
        print(score)
        return score
    }

}
