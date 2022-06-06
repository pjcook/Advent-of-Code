import Foundation
import StandardLibraries

public struct Day7 {
    public init() {}
    public typealias Reducer = (Int, (Int, Int)) throws -> Int

    /*
     Each submarine has a horizontal position (puzzle input). Moving 1 step costs 1 fuel. What is the least amount of fuel required to align all submarines to the same position?
     */
    public func part1(_ input: [Int]) -> Int {
        let sorted = input.sorted()
//        let min = sorted.first!
        let max = sorted.last!
        let median = sorted[input.count / 2]
        var mini = Int.max
        for i in (median...max) {
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
        let dict = reduce(input)
        var mini = Int.max
        let sorted = input.sorted()
        let max = sorted.last!
        let median = sorted[sorted.count / 2]
        for i in (median...max) {
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
//        let min = sorted.first!
        let max = sorted.last!
        let median = sorted[input.count / 2]
        var mini = Int.max
        for i in (median...max) {
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
        let dict = reduce(input)
        var mini = Int.max
        let sorted = input.sorted()
        let max = sorted.last!
        let median = sorted[sorted.count / 2]
        for i in (median...max) {
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
    
    public func reduce(_ input: [Int]) -> [Int:Int] {
        var dict = [Int:Int]()
        for i in input {
            dict[i] = dict[i, default: 0] + 1
        }
        return dict
    }
}
