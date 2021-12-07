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
    
    public func part1b(_ input: [Int]) -> Int {
        var dict = [Int:Int]()
        var min = Int.max
        var max = 0
        for i in input {
            dict[i] = dict[i, default: 0] + 1
            if i < min {
                min = i
            }
            if i > max {
                max = i
            }
        }
        var mini = Int.max
        for i in (min...max) {
            let result = dict.reduce(0) {
                $0 + abs(i - $1.0) * $1.1
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
    
    public func part2b(_ input: [Int]) -> Int {
        var dict = [Int:Int]()
        var min = Int.max
        var max = 0
        for i in input {
            dict[i] = dict[i, default: 0] + 1
            if i < min {
                min = i
            }
            if i > max {
                max = i
            }
        }
        var mini = Int.max
        for i in (min...max) {
            let result = dict.reduce(0) {
                let n = abs(i - $1.0)
                return $0 + (n * (n + 1) / 2) * $1.1
            }

            if result < mini {
                mini = result
            } else {
                break
            }
        }
        return mini
    }
}
