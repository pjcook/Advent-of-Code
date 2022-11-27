import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: String) throws -> Int {
        let regex = try RegularExpression(pattern: "(-?\\d+)")
        let matches = regex.matches(in: input)
        return try matches.reduce(0) { partialResult, match in
            try partialResult + match.integer(at: 0)
        }
    }
    
    public func part2(_ input: String) throws -> Int {
        let dict = try JSONSerialization.jsonObject(with: input.data(using: .utf8)!, options: .fragmentsAllowed) as! [String : Any]
        
        return count(dict)
    }
    
    public func count(_ input: [String:Any]) -> Int {
        var total = 0
        for value in input.values {
            if value is String && (value as! String) == "red" {
                total = 0
                break
            } else if value is Int {
                total += value as! Int
            } else if value is [String:Any] {
                total += count(value as! [String:Any])
            } else if value is [Any] {
                total += count(value as! [Any])
            }
        }
        return total
    }
    
    public func count(_ input: [Any]) -> Int {
        var total = 0
        
        for value in input {
            if value is Int {
                total += value as! Int
            } else if value is [String:Any] {
                total += count(value as! [String:Any])
            } else if value is [Any] {
                total += count(value as! [Any])
            }
        }
        
        return total
    }
}
