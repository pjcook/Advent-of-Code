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
            let lower = halfway-i
            let result = (time-lower) * lower
            if result > distance {
                count += 2
            }
            if result <= distance {
                if (time-(halfway+i-1)) * (halfway+i-1) <= distance {
                    count -= 1
                } else if (time-(halfway+i)) * (halfway+i) > distance {
                    count += 1
                }
                break
            }
        }
        
        return count
    }
}
