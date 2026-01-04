import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        parse(input).map { smallestNumberOfButtons($0) }.reduce(0, +)
    }

    public func part2(_ input: [String]) -> Int {
        0
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
