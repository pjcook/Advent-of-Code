import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        guard let (values, problems) = try? parse(input) else { return 0 }
        var total: Int = 0
        let columns = problems.count

        for column in 0..<columns {
            let valuesInColumn = values.map { $0[column] }
            let problem = problems[column]
            calculate(total: &total, values: valuesInColumn, problem: problem)
        }

        return total
    }

    public func part2(_ input: [String]) -> Int {
        let columns = input.first!.count
        var problem = Problem.add
        var values: [Int] = []
        var total = 0

        problem = findProblem(at: 0, in: input)

        for x in 0..<columns {
            var digits: String = ""
            for y in 0..<input.count - 1 {
                digits.append(String(input[y][x]))
            }

            let value = Int(digits.compactMap { Int(String($0)) == nil ? nil : String($0) }.joined())

            guard let value else {
                calculate(total: &total, values: values, problem: problem)
                values.removeAll()

                if x + 1 < columns {
                    problem = findProblem(at: x + 1, in: input)
                }
                continue
            }
            values.append(value)
        }

        calculate(total: &total, values: values, problem: problem)

        return total
    }

    enum Problem {
        case multiply
        case add
    }
}

extension Day6 {
    func calculate(total: inout Int, values: [Int], problem: Problem) {
        switch problem {
            case .add:
                total += values.reduce(0, +)

            case .multiply:
                total += values.reduce(1, *)
        }
    }

    func findProblem(at index: Int, in input: [String]) -> Problem {
        switch input.last![index] {
            case "+": .add
            case "*": .multiply
            default: .add
        }
    }

    func parse(_ input: [String]) throws -> ([[Int]], [Problem]) {
        var input = input
        let regex = try RegularExpression(pattern: "(\\d+)\\s*")
        let regex2 = try RegularExpression(pattern: "([+*]+)\\s*")
        var results: [[Int]] = []
        var lastLine: String = input.removeLast()
        while input.isEmpty {
            lastLine = input.removeLast()
        }

        for line in input {
            let matches = try regex
                .matches(in: line)
                .compactMap { try $0.integer(at: 0) }
            results.append(matches)
        }

        let problems = try regex2
            .matches(in: lastLine)
            .map {
                if try $0.string(at: 0) == "+" {
                    return Problem.add
                } else {
                    return Problem.multiply
                }
            }

        return (results, problems)
    }
}
