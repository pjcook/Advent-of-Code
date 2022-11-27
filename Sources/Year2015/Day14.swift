import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}

    public static let regex = try! RegularExpression(pattern: "^(\\w+) can fly (\\d+) km/s for (\\d+) seconds, but then must rest for (\\d+) seconds.$")

    public struct Reindeer {
        public let name: String
        public let speed: Int
        public let time: Int
        public let rest: Int
        
        public init(_ input: String) throws {
            let match = try Day14.regex.match(input)
            name = try match.string(at: 0)
            speed = try match.integer(at: 1)
            time = try match.integer(at: 2)
            rest = try match.integer(at: 3)
        }
        
        public func distance(in seconds: Int) -> Int {
            let sum = time + rest
            let count = Int(floor(Double(seconds / sum)))
            let remainder = seconds % sum
            return count * time * speed + min(remainder, time) * speed
        }
    }
    
    public func part1(_ input: [String], totalTime: Int) throws -> Int {
        let reindeer = try parse(input)
        var maxDistance: Int = 0
        
        for deer in reindeer {
            maxDistance = max(maxDistance, deer.distance(in: totalTime))
        }
        
        return maxDistance
    }
    
    public func part2(_ input: [String], totalTime: Int) throws -> Int {
        let reindeer = try parse(input)
        var scores = [String: Int]()
        
        for time in (1...totalTime) {
            var maxDistance = 0
            var winners = [String]()
            for deer in reindeer {
                let distance = deer.distance(in: time)
                if distance == maxDistance {
                    winners.append(deer.name)
                } else if distance > maxDistance {
                    winners = [deer.name]
                    maxDistance = distance
                }
            }
            for winner in winners {
                scores[winner] = scores[winner, default: 0] + 1
            }
        }
        
        return scores.values.sorted().last ?? -1
    }
    
    public func parse(_ input: [String]) throws -> [Reindeer] {
        try input.map(Reindeer.init)
    }
}
