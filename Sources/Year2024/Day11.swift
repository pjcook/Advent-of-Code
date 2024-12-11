import Foundation
import StandardLibraries

public final class Day11 {
    public init() {}
    
    struct CacheKey: Hashable {
        let value: Int
        let depth: Int
    }
    private var cache = [CacheKey: Int]()
    
    public func solve(_ input: String, iterations: Int) -> Int {
        var stones = input.components(separatedBy: " ").map { Int($0)! }
        
        for i in 0..<iterations {
            stones = blink(stones)
            print(i+1, stones.count)
        }
        
        return stones.count
    }
    
    public func solve2(_ input: String, iterations: Int) -> Int {
        let stones = input.components(separatedBy: " ").map { Int($0)! }
        var results = 0
        for stone in stones {
            results += blink2(stone, depth: 0, maxDepth: iterations)
        }
        return results
    }
}

extension Day11 {
    func blink(_ stones: [Int]) -> [Int] {
        var results = [Int]()
        
        for stone in stones {
            if stone == 0 {
                results.append(1)
            } else if stone.length.isEven {
                let dx = pow(10, stone.length / 2)
                let left = stone / dx
                let right = stone - (left * dx)
                results.append(left)
                results.append(right)
            } else {
                results.append(stone * 2024)
            }
        }
        
        return results
    }
    
    func blink2(_ stone: Int, depth: Int, maxDepth: Int) -> Int {
        guard depth < maxDepth else { return 1 }
        
        let cacheKey = CacheKey(value: stone, depth: depth)
        if let result = cache[cacheKey] {
            return result
        }
        
        let stones = blink([stone])
        var results = 0
        
        for s in stones {
            results += blink2(s, depth: depth + 1, maxDepth: maxDepth)
        }
        
        cache[cacheKey] = results
        return results
    }
}
