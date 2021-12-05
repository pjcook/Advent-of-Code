import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: Int, start: Int = 1) -> Int {
        var result = 0
        var count = start
        while result != input {
            var newResult = 0
            for i in (1..<(count/2)+1) {
                if count % i == 0 {
//                    print(count, i, count / i * 10)
                    newResult += count / i * 10
                }
            }
            newResult += 10 // For the current number
            result = newResult
//            print("-", count, result)
//            print()
            count += 1
        }
        return count-1
    }
    
    public func part2(_ input: Int) -> Int {
        return 0
    }
}
