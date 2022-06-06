import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    /*
     Naive brute force solution, just use Part 2 solution for both solutions
     */
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
    
    /*
     There are 8 days, but the first day is zero, so there needs to be 9 positions to map the fish growth.
     
     You can cycle the fish in an array by dropping the first element, copying all the fish from that to position 6 (because existing fish take 6 days to spawn), and appending the same value at the end (effectively day 8)
     */
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
