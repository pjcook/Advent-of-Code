import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    public func part1(time: [Int], distance: [Int]) -> Int {
        var results = [Int]()
        for (t,d) in zip(time, distance) {
            results.append(countWins(time: t, distance: d))
        }
        return results.reduce(1, *)
    }
    
    public func part2(time: Int, distance: Int) -> Int {
        countWins(time: time, distance: distance)
    }
    
    func countWins(time: Int, distance: Int) -> Int {
        let halfway = time / 2
        var count = 1
        for i in (1..<halfway) {
            let upper = halfway+i
            let lower = halfway-i
            let result1 = (time-upper) * upper
            let result2 = (time-lower) * lower
            if result1 > distance {
                count += 1
            }
            if result2 > distance {
                count += 1
            }
            if result1 <= distance || result2 <= distance {
                break
            }
        }
        
        return count
    }
}
