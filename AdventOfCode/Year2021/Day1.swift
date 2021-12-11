import Foundation
import StandardLibraries

public struct Day1 {
    public init() {}
    
    /*
     Count the number of times a depth measurement increases from the previous measurement. (There is no measurement before the first measurement.)
     
     199 (N/A - no previous measurement)
     200 (increased)
     208 (increased)
     210 (increased)
     200 (decreased)
     207 (increased)
     240 (increased)
     269 (increased)
     260 (decreased)
     263 (increased)
     */
    public func part1(_ input: [Int]) -> Int {
        var count = 0
        // Start at position 1 (for a 0 based array) and look back at the previous value to compare to make sure you don't go out of bounds
        for i in (1..<input.count) {
            // Compare with the value in the previous array index
            if input[i-1] < input[i] {
                count += 1
            }
        }
        return count
    }
    
    /*
     Consider sums of a three-measurement sliding window
     
     199  A
     200  A B
     208  A B C
     210    B C D
     200  E   C D
     207  E F   D
     240  E F G
     269    F G H
     260      G H
     263        H
     
     In the above example, the sum of each three-measurement window is as follows:

     A: 607 (N/A - no previous sum)
     B: 618 (increased)
     C: 618 (no change)
     D: 617 (decreased)
     E: 647 (increased)
     F: 716 (increased)
     G: 769 (increased)
     H: 792 (increased)
     
     Your goal now is to count the number of times the sum of measurements in this sliding window increases from the previous sum.
     */
    public func part2(_ input: [Int]) -> Int {
        var count = 0
        // Store the initial value
        var prev = input[0] + input[1] + input[2]
        // Start at position 3 (for a 0 based array) and look back at the previous value to compare to make sure you don't go out of bounds
        for i in (3..<input.count) {
            // Calculate the current 3 position window current index, current index - 1, current index - 2
            let sum = input[i-2] + input[i-1] + input[i]
            // Compare with the value in the previous array index
            if prev < sum {
                count += 1
            }
            prev = sum
        }
        return count
    }
}
