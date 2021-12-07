import Foundation
import StandardLibraries

public struct Day7 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        let sorted = input.sorted()
        let min = sorted.first!
        let max = sorted.last!
        var mini = Int.max
        for i in (min...max) {
            let result = input.reduce(0) {
                $0 + abs(i - $1)
            }

            if result < mini {
                mini = result
            } else {
                break
            }
        }
        return mini
    }
    
    public func part2(_ input: [Int]) -> Int {
        let sorted = input.sorted()
        let min = sorted.first!
        let max = sorted.last!
        var mini = Int.max
        for i in (min...max) {
            let result = input.reduce(0) {
                let n = abs(i - $1)
                return $0 + (n * (n + 1) / 2)
            }
            
            if result < mini {
                mini = result
            }
        }
        return mini
    }
}
