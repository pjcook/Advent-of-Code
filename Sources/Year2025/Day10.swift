import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        parse(input).map { smallestNumberOfButtons($0) }.reduce(0, +)
    }

    public func part2(_ input: [String]) -> Int {
        parse(input).map { configureJoltage($0, current: $0.joltage) }.reduce(0, +)
    }

    typealias Button = [Int]

    struct Machine {
        let lights: [Bool]
        let buttons: [Button]
        let joltage: [Int]
        var defaultLightsState: [Bool] {
            lights.map { _ in false }
        }
        var defaultJoltageState: [Int] {
            joltage.map { _ in 0 }
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
            self.buttons = parts[1..<parts.count-1].map {
                $0.components(separatedBy: ",")
                    .map { Int($0)! }
            }
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

    func configureJoltage(_ machine: Machine, current: [Int], currentLowest: Int = Int.max, level: Int = 0) -> Int {
        guard currentLowest > level else {
            return level
        }

        var lowest = Int.max

        for button in buttons(for: machine, current: current) {
            let newJoltage = toggle(joltage: current, with: button)
            if isZero(newJoltage) {
                return level + 1
            } else if isValid(newJoltage) {
                if let cacheValue = seen[newJoltage], cacheValue < level + 1 {
                    continue
                }

                let result = configureJoltage(machine, current: newJoltage, currentLowest: lowest, level: level + 1)

                lowest = min(lowest, result)
                seen[newJoltage] = min(seen[newJoltage, default: result], result)
//                if lowest != Int.max && level > 3 {
//                    return lowest
//                }
            }
        }

//        if lowest != Int.max {
//            print(lowest)
//        }

        return lowest
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

    func toggle(lights: [Bool], with: [Int]) -> [Bool] {
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
