import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        parse(input).map { smallestNumberOfButtons($0) }.reduce(0, +)
    }

    public func part2(_ input: [String]) -> Int {
        parse(input).map { configureJoltage($0) }.reduce(0, +)
    }

    typealias Button = Set<Int>

    struct Machine {
        let lights: [Bool]
        let buttons: [Button]
        let joltage: [Int]
        let defaultLightsState: [Bool]
        let defaultJoltageState: [Int]

        init(buttons: [Button], joltage: [Int]) {
            self.lights = []
            self.buttons = buttons
            self.joltage = joltage
            self.defaultLightsState = []
            self.defaultJoltageState = []
        }

        init(_ line: String) {
            let parts = line
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: "")
                .components(separatedBy: " ")
            self.lights = parts[0].map { $0 == "." ? false : true }
            self.joltage = parts.last!
                .components(separatedBy: ",")
                .map { Int($0)! }
            self.buttons = parts[1..<parts.count-1]
                .map {
                    Set($0.components(separatedBy: ",")
                        .map { Int($0)! })
                }
            self.defaultLightsState = lights.map { _ in false }
            self.defaultJoltageState = joltage.map { _ in 0 }
        }

        func sortedJoltage() -> [(Int, Int)] {
            joltage.enumerated()
                .map { ($0, $1) }
                .sorted { $0.1 > $1.1 }
        }
    }
}

private var seen: [[Int]:Int] = [:]

extension Day10 {
    func smallestNumberOfButtons(_ machine: Machine) -> Int {
        var queue: [([Bool], Int)] = []
        queue.append((machine.defaultLightsState, 0))

        while true {
            var newQueue: [([Bool], Int)] = []

            for (lights, level) in queue {
                for button in machine.buttons {
                    let newLights = toggle(lights: lights, with: button)
                    if machine.lights == newLights {
                        return level + 1
                    }
                    newQueue.append((newLights, level + 1))
                }
            }

            queue = newQueue
        }

        return 0
    }

    /*
     from functools import cache
     from itertools import combinations, product
     import aocd

     def patterns(coeffs: list[tuple[int, ...]]) -> dict[tuple[int, ...], dict[tuple[int, ...], int]]:
     num_buttons = len(coeffs)
     num_variables = len(coeffs[0])
     out = {parity_pattern: {} for parity_pattern in product(range(2), repeat=num_variables)}
     for num_pressed_buttons in range(num_buttons+1):
     for buttons in combinations(range(num_buttons), num_pressed_buttons):
     pattern = tuple(map(sum, zip((0,) * num_variables, *(coeffs[i] for i in buttons))))
     parity_pattern = tuple(i%2 for i in pattern)
     if pattern not in out[parity_pattern]:
     out[parity_pattern][pattern] = num_pressed_buttons
     return out

     def solve_single(coeffs: list[tuple[int, ...]], goal: tuple[int, ...]) -> int:
     pattern_costs = patterns(coeffs)
     @cache
     def solve_single_aux(goal: tuple[int, ...]) -> int:
     if all(i == 0 for i in goal): return 0
     answer = 1000000
     for pattern, pattern_cost in pattern_costs[tuple(i%2 for i in goal)].items():
     if all(i <= j for i, j in zip(pattern, goal)):
     new_goal = tuple((j - i)//2 for i, j in zip(pattern, goal))
     answer = min(answer, pattern_cost + 2 * solve_single_aux(new_goal))
     return answer
     return solve_single_aux(goal)

     def solve(raw: str):
     score = 0
     lines = raw.splitlines()
     for I, L in enumerate(lines, 1):
     _, *coeffs, goal = L.split()
     goal = tuple(int(i) for i in goal[1:-1].split(","))
     coeffs = [[int(i) for i in r[1:-1].split(",")] for r in coeffs]
     coeffs = [tuple(int(i in r) for i in range(len(goal))) for r in coeffs]

     subscore = solve_single(coeffs, goal)
     print(f'Line {I}/{len(lines)}: answer {subscore}')
     score += subscore
     print(score)

     # solve(open('input/10.test').read())
     solve(aocd.get_data(year=2025, day=10))
     */

    func configureJoltage(_ machine: Machine, level: Int = 0) -> Int {
        1
    }

    func configureJoltage2(_ machine: Machine, level: Int = 0) -> Int {

        guard machine.joltage.reduce(0, +) > 0 else { return level }
        var lowestLevel = Int.max

        let sortedJoltage = machine.sortedJoltage()
        let remainingIndexes = Set(sortedJoltage.map({ $0.0 }))

        for button in machine.buttons where button.isSubset(of: remainingIndexes) {
            var lowest = Int.max
            for index in button {
                lowest = min(lowest, sortedJoltage.first { $0.0 == index }!.1)
            }

            var joltage = machine.joltage
            for index in button {
                joltage[index] -= lowest
            }

            lowestLevel = min(lowestLevel, configureJoltage(Machine(buttons: machine.buttons, joltage: joltage), level: level + 1))
        }

        return lowestLevel
    }

    func isZero(_ joltage: [Int]) -> Bool {
        for i in 0..<joltage.count {
            if joltage[i] != 0 {
                return false
            }
        }
        return true
    }

    func isValid(_ joltage: [Int]) -> Bool {
        for i in 0..<joltage.count {
            if joltage[i] < 0 {
                return false
            }
        }
        return true
    }

    func buttons(for machine: Machine, current joltage: [Int]) -> [Button] {
        var buttons: [Button] = []
        let indexes = Set(largestJoltageIndexes(joltage))
        for button in machine.buttons {
            if Set(button).isSuperset(of: indexes) {
                buttons.insert(button, at: 0)
            } else {
                buttons.append(button)
            }
        }

        return buttons
    }

    func largestJoltageIndexes(_ joltage: [Int]) -> [Int] {
        let high = joltage.max()!
        var indexes: [Int] = []
        for i in 0..<joltage.count {
            if joltage[i] == high {
                indexes.append(i)
            }
        }
        return indexes
    }

    func toggle(joltage: [Int], with: [Int]) -> [Int] {
        var joltage = joltage
        for index in with {
            joltage[index] -= 1
        }
        return joltage
    }

    func toggle(lights: [Bool], with: Set<Int>) -> [Bool] {
        var lights = lights
        for index in with {
            lights[index].toggle()
        }
        return lights
    }

    func parse(_ input: [String]) -> [Machine] {
        input.map(Machine.init)
    }
}
