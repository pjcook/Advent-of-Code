import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    /*
     Time:      7  15   30
     Distance:  9  40  200
     */
    public func part1(time: [Int], distance: [Int]) -> Int {
        var results = [Int]()
        for (t,d) in zip(time, distance) {
            var count = 0
            for i in (1..<t) {
                let result = (t-i) * i
                if result > d {
                    count += 1
                }
            }
            if count > 0 {
                results.append(count)
            }
        }
        return results.reduce(1, *)
    }
    
    public func part2(time: Int, distance: Int) -> Int {
        let halfway = time / 2
        var count = 0
        for i in (halfway..<time) {
            let result = (time-i) * i
            if result > distance {
                count += 1
            } else {
                break
            }
        }
        
        for j in (1..<halfway) {
            let i = halfway - j
            let result = (time-i) * i
            if result > distance {
                count += 1
            } else {
                break
            }
        }
        return count
    }
}
