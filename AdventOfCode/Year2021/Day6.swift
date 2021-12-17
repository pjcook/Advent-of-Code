import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    public func part1(_ input: [Int], days: Int) -> Int {
        var fishes = input
        for _ in (0..<days) {
            for (index, fish) in fishes.enumerated() {
                let timer = fish - 1
                fishes[index] = timer
                if timer == -1 {
                    fishes.append(8)
                    fishes[index] = 6
                }
            }
        }
        return fishes.count
    }
    
    public func part2(_ input: [Int], days: Int) -> Int {
        var fishes = Array(repeating: 0, count: 9)
        for i in input {
            fishes[i] = fishes[i] + 1
        }
        for _ in (0..<days) {
            let value = fishes.removeFirst()
            fishes[6] = fishes[6] + value
            fishes.append(value)
        }
        return fishes.reduce(0, +)
    }
}
