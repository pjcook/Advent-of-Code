import Foundation
import StandardLibraries

public struct Day17 {
    public init() {}
    
    public func part1(_ input: [Int], litres: Int = 150) -> Int {
        var results = [[Int]:Int]()
        process(key: [], remainingOptions: input.sorted().reversed(), litresRemaining: litres, results: &results)
        
        return results.reduce(0, { $0 + $1.value })
    }
    
    public func part2(_ input: [Int], litres: Int = 150) -> Int {
        var results = [[Int]:Int]()
        process(key: [], remainingOptions: input.sorted().reversed(), litresRemaining: litres, results: &results)
        let smallest = results.keys.reduce(Int.max, { $1.count < $0 ? $1.count : $0 })
        return results.filter({ $0.key.count == smallest}).reduce(0, { $0 + $1.value })
    }

    public func process(key: [Int], remainingOptions: [Int], litresRemaining: Int, results: inout [[Int]:Int]) {
        var remainingValues = remainingOptions
        
        while !remainingValues.isEmpty {
            let value = remainingValues.removeFirst()
            if litresRemaining - value < 0 {
                continue
            } else if litresRemaining - value == 0 {
                var newKey = key
                newKey.append(value)
                newKey = newKey.sorted().reversed()
                results[newKey] = results[newKey, default: 0] + 1
            } else {
                var newKey = key
                newKey.append(value)
                process(key: newKey, remainingOptions: remainingValues.filter({ litresRemaining - $0 >= 0 }), litresRemaining: litresRemaining-value, results: &results)
            }
        }
    }
}
