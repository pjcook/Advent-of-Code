import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        var output = input
        
        for i in (0..<40) {
            print(i, output.count)
            output = process(output)
        }
        
        return output.count
    }
    
    public func part2(_ input: [Int]) -> Int {
        var output = input
        
        for i in (0..<50) {
            print(i, output.count)
            output = process(output)
        }
        
        return output.count
    }
    
    public func process(_ input: [Int]) -> [Int] {
        var output = [Int]()
        var prev = input[0]
        var count = 1
        
        for i in (1..<input.count) {
            let current = input[i]
            if prev == current {
                count += 1
            } else {
                output.append(count)
                output.append(prev)
                count = 1
                prev = current
            }
        }
        
        output.append(count)
        output.append(prev)

        return output
    }
}
